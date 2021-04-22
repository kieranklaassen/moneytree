require "active_support/concern"

module Moneytree
  module Order
    extend ActiveSupport::Concern

    included do
      has_many :moneytree_transactions, class_name: "Moneytree::Transaction", foreign_key: "order_id", inverse_of: :order, as: :order
    end

    def current_payment
      moneytree_transactions.payment.initialized.first_or_initialize
    end

    # Tell the PSP to check the status on pending transactions
    def check_payment_status!
      moneytree_transactions.payment.each(&:fetch_status!)
    end

    def new_payment(*args)
      payment = Payment.new(*args)
      moneytree_transactions << payment
      payment
    end
  end
end
