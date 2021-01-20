# frozen_string_literal: true

module Moneytree
  module Webhooks
    class SquareController < Moneytree::ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        # Do some callback magic here
      end
    end
  end
end
