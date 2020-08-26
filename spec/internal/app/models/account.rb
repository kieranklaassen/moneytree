class Account < ApplicationRecord
  include Moneytree::Account

  has_many :orders
  has_many :transactions
  has_many :customers
  has_many :cards
end
