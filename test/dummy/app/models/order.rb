class Order < ApplicationRecord
  include Moneytree::Order

  has_many :merchant_orders

  def process_webhook_transaction(transaction)
    puts "ORDER UPDATED BECAUSE TRANSACTION WAS #{transaction.status}"
  end
end
