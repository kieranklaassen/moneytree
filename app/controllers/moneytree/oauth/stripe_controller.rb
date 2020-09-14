module Moneytree
  module Oauth
    class StripeController < MoneytreeController
      def new
        redirect_to current_account.oauth_link
      end

      def callback
        # https://stripe.com/docs/connect/oauth-reference#get-authorize-response
        current_account.oauth_callback(params) # FIXME: Add strong parameter for code only
        render text: 'Boom'
      end
    end
  end
end
