module Moneytree
  module PaymentProvider
    class Square < Base
      # The permissions we request from Square OAuth, we store them in the database
      PERMISSIONS = %i[
        merchant_profile_read
        payments_write
        payments_read
        customers_write
        payments_write_additional_recipients
      ].freeze

      def oauth_link
        "#{credentitals[:oauth_domain]}/oauth2/authorize?client_id=#{credentitals[:app_id]}&scope=#{PERMISSIONS.join('+').upcase}"
      end

      def oauth_callback(_params)
        # https://developer.squareup.com/docs/oauth-api/walkthrough
        {
          scope: PERMISSIONS,
          access_token: '123',
          refresh_token: '567',
          expires_at: '',
          token_type: 'bearer',
          merchant_id: 'safsf'
        }
      end

      def test_credentials
        client.sdfsdf
      rescue StandardError
        raise 'Not working'
      end

      def scope_correct?
        @account.psp_credentials.scope.sort == PERMISSIONS.sort
      end

      def client
        @client ||= Square::Client.new(
          access_token: @account.psp_credentials.square_access_token,
          environment: credentitals[:environment]
        )
      end

      private

      def credentitals
        Moneytree.square_credentials
      end
    end
  end
end
