require_dependency "moneytree/application_controller"

module Moneytree
  class MoneytreeController < ApplicationController

  private

  def current_account
    send(Moneytree.current_account)
  end
end
