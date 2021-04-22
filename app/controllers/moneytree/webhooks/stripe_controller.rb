module Moneytree
  module Webhooks
    class StripeController < Moneytree::ApplicationController
      include Moneytree::StripeConfirmable

      skip_before_action :verify_authenticity_token

      def create
        case webhook_params.type
        when "charge.succeeded"
          process_charge!
        when "charge.refunded"
          process_refund!
        when "account.updated"
          process_account_updated!
        else
          puts "Unhandled event type: #{webhook_params.type}"
        end

        head :ok
      end

      private

      def webhook_params
        sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

        @webhook_params ||= ::Stripe::Webhook.construct_event(
          payload,
          request.env["HTTP_STRIPE_SIGNATURE"],
          webhook_secret
        )
      rescue JSON::ParserError, Stripe::SignatureVerificationError
        raise ActionDispatch::Http::Parameters::ParseError # Will return status 400
      end

      def process_charge!
        return if transaction.completed?

        transaction.process_response(
          Moneytree::PspResponse.new(:success, "", {charge_id: stripe_object.id})
        )
      end

      def process_refund!
        stripe_object.refunds.data.each do |stripe_refund_object|
          # TODO: Create refund transaction in db for PSP-initiated refunds
          next if stripe_refund_object.metadata[:moneytree_transaction_id].blank?

          refund = transaction.refunds.find(stripe_refund_object.metadata[:moneytree_transaction_id])

          next if refund.completed?

          refund.process_response(
            Moneytree::PspResponse.new(:success, "")
          )
        end
      end

      def process_account_updated!
        return if stripe_object.metadata[:payment_gateway_id].blank?

        payment_gateway = Moneytree::PaymentGateway.find(stripe_object.metadata[:payment_gateway_id].to_i)
        confirm_stripe_account(payment_gateway, stripe_object)
      end

      def transaction
        @transaction ||= Moneytree::Transaction.find(stripe_object.metadata[:moneytree_transaction_id])
      end

      def stripe_object
        @stripe_object ||= webhook_params.data.object
      end

      def payload
        @payload ||= request.body.read
      end

      def webhook_secret
        case JSON.parse(payload)["type"]
        when "charge.succeeded", "charge.refunded"
          Moneytree.stripe_credentials[:account_webhook_secret]
        when "account.updated"
          Moneytree.stripe_credentials[:connect_webhook_secret]
        end
      end
    end
  end
end
