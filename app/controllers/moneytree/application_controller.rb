module Moneytree
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception

    def __current_account
      send(Moneytree.current_account_accessor)
    end
  end
end
