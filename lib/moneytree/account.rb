require 'active_support/concern'

module Moneytree
  module Account
    extend ActiveSupport::Concern

    included do
      has_one :moneytree_payment_gateway, class_name: 'Moneytree::PaymentGateway', foreign_key: 'account_id', inverse_of: :account, as: :account
    end
  end
end
