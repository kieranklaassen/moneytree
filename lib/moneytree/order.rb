require 'active_support/concern'

module Moneytree
  module Order
    extend ActiveSupport::Concern

    included do
      has_many :moneytree_transactions, class_name: 'Moneytree::Transaction', foreign_key: 'order_id'
    end

    # def charge(**args)
    #   moneytree_transactions.new(**args)
    # end

    def charge!(_payment_method, account, amount, app_fee_amount = 0)
      # TODO: add error handling
      moneytree_transactions.create!(account: account, amount: amount, app_fee_amount: app_fee_amount)
    end

    # def charge_later(**args)
    #   moneytree_transactions.create_later(**args)
    # end
  end
end
