module Moneytree
  class Payout < Moneytree::Transfer
    belongs_to :payment
    has_many :reverse_payouts

    def execute
      process_respopnse(
        payment_gateway.payout(payment.details, amount, metadata: { moneytree_transfer_id: id })
      )
    end
  end
end
