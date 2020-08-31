class Account < ApplicationRecord
  include Moneytree::Account
  # moneytree :account, options: {sdfsdf}

  has_many :orders
  has_many :transactions
  has_many :customers
  has_many :cards
end
