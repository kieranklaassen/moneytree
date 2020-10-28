module Moneytree
  module PaymentProvider
    class Stripe < Base
      # The permissions we request from Square OAuth, we store them in the database
      PERMISSION = :read_write

      def initialize(args)
        raise Error, 'Please set your Stripe credentials' if credentitals.nil?
        raise Error, 'Please include the stripe gem to your Gemfile' unless Object.const_defined?('::Stripe')

        ::Stripe.api_key = credentitals[:api_key]
        super
      end

      def get_access_token(params)
        # FIXME: add error handling
        ::Stripe::OAuth.token(
          {
            grant_type: 'authorization_code',
            code: params[:code]
          }
        ).to_hash
      end

      def scope
        PERMISSION.to_s
      end

      def charge(amount, details, app_fee_amount: 0, description: "Charge for #{account.name}", metadata:)
        # `source` is obtained with Stripe.js; see https://stripe.com/docs/payments/accept-a-payment-charges#web-create-token
        response = ::Stripe::Charge.create(
          {
            amount: (amount * 100).to_i,
            currency: account.currency_code,
            source: details[:card_token],
            description: description,
            metadata: metadata,
            application_fee_amount: (app_fee_amount * 100).to_i
          },
          stripe_account: payment_gateway.psp_credentials[:stripe_user_id]
        )
        # succeeded, pending, or failed
        TransactionResponse.new(
          { succeeded: :success, pending: :pending, failed: :failed }[response[:status].to_sym],
          response[:failure_message],
          { charge_id: response[:id] }
        )
      rescue ::Stripe::StripeError => e
        TransactionResponse.new(:failed, e.message)
      end

      def refund(amount, details, reason, metadata:)
        response = ::Stripe::Refund.create(
          {
            charge: details[:charge_id],
            amount: (-amount * 100).to_i,
            metadata: metadata,
            reason: reason,
            refund_application_fee: Moneytree.refund_application_fee
          }
        )
    end

      private

      def credentitals
        Moneytree.stripe_credentials
      end
    end
  end
end
