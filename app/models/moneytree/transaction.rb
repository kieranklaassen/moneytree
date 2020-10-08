module Moneytree
  class Transaction < ApplicationRecord
    belongs_to :payment_gateway
    belongs_to :order, polymorphic: true
  end
end
