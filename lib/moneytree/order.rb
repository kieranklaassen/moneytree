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

    def charge!(_account, _amount, _fee = 0)
      moneytree_transactions.create!(**args)
    end

    # def charge_later(**args)
    #   moneytree_transactions.create_later(**args)
    # end
  end
end
