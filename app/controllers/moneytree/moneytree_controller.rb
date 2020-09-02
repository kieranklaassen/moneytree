module Moneytree
  class MoneytreeController < ApplicationController

  private

  def current_account
    send(Moneytree.current_account)
  end
end
