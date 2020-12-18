class MerchantOrder < ApplicationRecord
  include Moneytree::AccountOrder

  belongs_to :order
  belongs_to :merchant
end
