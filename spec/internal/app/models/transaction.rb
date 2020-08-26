class Transaction < ApplicationRecord
  belongs_to :card
  belongs_to :account
  belongs_to :order
end
