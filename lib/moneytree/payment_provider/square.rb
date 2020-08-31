module Moneytree
  module PaymentProvider
    class Square
      # The permissions we request from Square OAuth, we store them in the database
      PERMISSIONS = %i[
        merchant_profile_read
        payments_write
        payments_read
        customers_write
        payments_write_additional_recipients
      ].freeze

      def initialize(account)
        @account = account
      end

      def oauth_link
        "#{credentitals[:oauth_domain]}/oauth2/authorize?client_id=#{credentitals[:app_id]}&scope=#{PERMISSIONS.join('+').upcase}"
      end

      def client
        @client ||= Square::Client.new(
          access_token: @account.psp_credentials.square_access_token,
          environment: @account.psp_credentials.square_environment
        )
      end

      private

      def credentitals
        Moneytree.square_credentials
      end
    end
  end
end
