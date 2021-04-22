# frozen_string_literal: true

module Moneytree
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception

    def __current_account
      send(Moneytree.current_account_accessor)
    end

    def authenticate
      return if Moneytree.authenticate.nil?

      raise ActionController::RoutingError, "Authentication failed" unless Moneytree.authenticate.call(request)
    end
  end
end
