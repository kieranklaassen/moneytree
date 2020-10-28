module Moneytree
  class Transaction < ApplicationRecord
    belongs_to :payment_gateway
    belongs_to :order, polymorphic: true

    enum status: %i[initialized pending completed failed]

    serialize :details

    after_create_commit :execute_transaction
  end
end
