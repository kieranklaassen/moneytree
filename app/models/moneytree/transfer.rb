module Moneytree
  class Moneytree::Transfer < ApplicationRecord
    belongs_to :payment_gateway
    belongs_to :account_order, polymorphic: true
    belongs_to :customer_transaction, foreign_key: :transaction_id, class_name: 'Moneytree::Transaction', optional: true

    enum status: %i[initialized completed failed]

    serialize :details

    def account_name
      payment_gateway.account.name
    end
  end
end
