module Moneytree
  module Webhooks
    class StripeController < Moneytree::ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        case webhook_params.type
        when 'charge.succeeded'
          process_charge!
        when 'charge.refunded'
          process_refund!
        when 'account.updated'
          process_account_updated!
        else
          puts "Unhandled event type: #{webhook_params.type}"
        end

        head :ok
      end

      private

      def webhook_params
        @webhook_params ||=
          ::Stripe::Event.construct_from(
            JSON.parse(request.body.read, symbolize_names: true)
          )
      end

      def process_charge!
        return if transaction.completed?

        transaction.process_response(
          Moneytree::TransactionResponse.new(:success, '', { charge_id: stripe_object.id })
        )

        if Moneytree.order_status_trigger_method
          transaction.order.send(Moneytree.order_status_trigger_method, transaction)
        end
      end

      def process_refund!
        stripe_object.refunds.data.each do |stripe_refund_object|
          # TODO: Create refund transaction in db for PSP-initiated refunds
          next if stripe_refund_object.metadata[:moneytree_transaction_id].blank?

          refund = transaction.refunds.find(stripe_refund_object.metadata[:moneytree_transaction_id])

          next if refund.completed?

          refund.process_response(
            Moneytree::TransactionResponse.new(:success, '')
          )
          if Moneytree.order_status_trigger_method
            transaction.order.send(Moneytree.order_status_trigger_method, transaction)
          end
        end
      end

      def process_account_updated!
        payment_gateway = PaymentGateway.find_by!(stripe_object.metadata.moneytree_id.to_i)
        payment_gateway.update!(onboarded: true) if stripe_object.details_submitted && !payment_gateway.onboarded?
      end

      def transaction
        @transaction ||= Moneytree::Transaction.find(stripe_object.metadata[:moneytree_transaction_id])
      end

      def stripe_object
        @stripe_object ||= webhook_params.data.object
      end
    end
  end
end
