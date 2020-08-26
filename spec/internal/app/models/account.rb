class Account < ApplicationRecord
  has_many :orders
  has_many :transactions
  has_many :customers
  has_many :cards

  enum psp: %i[square stripe braintree] # FIXME: Move to engine
end
