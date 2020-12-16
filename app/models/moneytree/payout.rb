module Moneytree
  class Payout < Moneytree::Transfer
    has_many :reverse_payouts
  end
end
