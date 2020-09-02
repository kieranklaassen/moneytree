module Moneytree
  module Ouath
    class SquareController < MoneytreeController
      def new
        redirect_to current_account.oauth_link
      end

      def create
        current_account.oauth_callback(params)
        render text: 'Boom'
      end
    end
  end
end
