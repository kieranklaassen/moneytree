module Moneytree
  module Oauth
    class SquareController < Moneytree::ApplicationController
      def new
        redirect_to current_account.oauth_link
      end

      def callback
        current_account.oauth_callback(params)
        render text: 'Boom'
      end
    end
  end
end
