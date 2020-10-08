class Order < ApplicationRecord
  include Moneytree::Order

  belongs_to :merchant
end
