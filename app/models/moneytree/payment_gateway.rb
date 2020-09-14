module Moneytree
  class PaymentGateway < ApplicationRecord
    include Moneytree::Account

    belongs_to :account, polymorphic: true

    # has_many :orders
    # has_many :transactions
    # has_many :customers
    # has_many :cards
  end
end
