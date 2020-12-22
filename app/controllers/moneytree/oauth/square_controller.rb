module Moneytree
  module Oauth
    class SquareController < Moneytree::ApplicationController
      def new
        redirect_to __current_account.oauth_link
      end

      def callback
        __current_account.oauth_callback(params)
        render text: 'Boom'
      end
    end
  end
end
