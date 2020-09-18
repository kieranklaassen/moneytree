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
        # https://stripe.com/docs/connect/oauth-reference#post-token
        # FIXME: add error handling
        payment_gateway.update! psp_credentials: params

        response = ::Stripe::OAuth.token({
          grant_type: 'authorization_code',
          code: params[:code]
        })
        payment_gateway.update! psp_credentials: response
      end

      def scope_correct?
        payment_gateway.psp_credentials&.dig(:scope) == PERMISSION.to_s
      end

      private

      def credentitals
        Moneytree.stripe_credentials
      end
    end
  end
end
