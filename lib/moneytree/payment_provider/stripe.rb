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

        TransactionResponse.new(response[:status].to_sym, response[:failure_message])
      rescue ::Stripe::StripeError => e
        TransactionResponse.new(:failed, e.message)
      end

      private

      def credentitals
        Moneytree.stripe_credentials
      end
    end
  end
end
