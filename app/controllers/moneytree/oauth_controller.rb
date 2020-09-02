module Moneytree
  class OauthController < ApplicationController
    def new
      redirect_to current_account.oauth_link
    end

    def create
      current_account.oauth_callback(params)
      render text: 'Boom'
    end
  end

  private

  def current_account
    send(Moneytree.current_account)
  end
end
