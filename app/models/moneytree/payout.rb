module Moneytree
  class Payout < Moneytree::Transfer
    has_many :reverse_payouts

    def execute!
      process_response(
        payment_gateway.payout(customer_transaction.details, amount, metadata: { moneytree_transfer_id: id })
      )
    end
  end
end
