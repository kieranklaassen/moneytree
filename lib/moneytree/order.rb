require 'active_support/concern'

module Moneytree
  module Order
    extend ActiveSupport::Concern

    included do
      has_many :merchant_orders
      has_many :moneytree_transactions, class_name: 'Moneytree::Transaction', foreign_key: 'order_id', inverse_of: :order, as: :order
    end

    def new_payment(*args)
      payment = Payment.new(*args)
      moneytree_transactions << payment
      payment
    end
  end
end
