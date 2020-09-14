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

      # https://stripe.com/docs/connect/oauth-reference
      def oauth_link
        # https://stripe.com/docs/connect/oauth-reference#get-authorize
        a = URI::HTTPS.build(
          host: 'connect.stripe.com',
          path: '/oauth/authorize',
          query: {
            response_type: :code,
            client_id: credentitals[:client_id],
            scope: PERMISSION,
            redirect_uri: 'http://loalhost:3000/mt/oauth/stripe/callback', # FIXME: use rails url helper and add host
            'stripe_user[email]': account.email,
            'stripe_user[url]': account.website,
            'stripe_user[currency]': account.currency_code
          }.to_query
        ).to_s
      end

      def oauth_callback(_params)
        # https://stripe.com/docs/connect/oauth-reference#get-authorize-response
        {
          scope: 'sdf',
          code: '123',
          state: 'sdf'
        }

        # Get refresh token
        # https://stripe.com/docs/connect/oauth-reference#post-token
      end

      def client
        nil
      end

      # def test_credentials
      #   client.sdfsdf
      # rescue StandardError
      #   raise 'Not working'
      # end

      def scope_correct?
        payment_gateway.psp_credentials&.dig(:scope) == PERMISSION
      end

      private

      def credentitals
        Moneytree.stripe_credentials
      end
    end
  end
end
