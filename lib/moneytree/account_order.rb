require 'active_support/concern'

module Moneytree
  module Order
    extend ActiveSupport::Concern

    included do
      has_many :moneytree_transfers, class_name: 'Moneytree::Transfer', foreign_key: 'account_order_id', inverse_of: :account_order, as: :account_order
    end
  end
end
