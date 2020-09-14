module Moneytree
  module PaymentProvider
    class Stripe < Base
      # The permissions we request from Square OAuth, we store them in the database
      PERMISSION = :read_write

      def initialize
        Stripe.api_key = credentitals[:api_key]
        super
      end

      # https://stripe.com/docs/connect/oauth-reference
      def oauth_link
        # https://stripe.com/docs/connect/oauth-reference#get-authorize
        URI::HTTP.build(
          host: 'https://connect.stripe.com',
          path: '/oauth/authorize',
          query: {
            response_type: :code,
            client_id: credentitals[:app_id],
            scope: PERMISSION,
            redirect_uri: stripe_oauth_url,
            'stripe_user[email]': @account.email,
            'stripe_user[url]': @account.website,
            'stripe_user[currency]': @account.currency
          }.to_query
        ).request_uri
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

      def test_credentials
        client.sdfsdf
      rescue StandardError
        raise 'Not working'
      end

      def scope_correct?
        @account.psp_credentials.scope.sort == PERMISSIONS.sort
      end

      private

      def credentitals
        Moneytree.stripe_credentials
      end
    end
  end
end
