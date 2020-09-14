class Account < ApplicationRecord
  has_one :payment_gateway, class_name: 'moneytree_payment_gateway', foreign_key: 'account_id'
end
