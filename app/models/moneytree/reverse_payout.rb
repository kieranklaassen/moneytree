module Moneytree
  class ReversePayout < Moneytree::Transfer
    belongs_to :payout
  end
end
