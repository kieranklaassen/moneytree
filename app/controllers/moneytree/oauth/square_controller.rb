# frozen_string_literal: true

module Moneytree
  module Oauth
    class SquareController < Moneytree::ApplicationController
      before_action :authenticate

      def new
        redirect_to __current_account.oauth_link
      end

      def callback
        __current_account.oauth_callback(params)
        render text: "Boom"
      end
    end
  end
end
