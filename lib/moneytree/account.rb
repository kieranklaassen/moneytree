require 'active_support/concern'

module Moneytree
  module Account
    extend ActiveSupport::Concern

    included do
      has_one :payment_gateway, class_name: 'moneytree_payment_gateway', foreign_key: 'account_id'
    end
  end
end
