class Transaction < ApplicationRecord
  include Moneytree::Transaction

  belongs_to :card
  belongs_to :account
  belongs_to :order
end
