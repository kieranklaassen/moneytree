module Moneytree
  class Payout < Moneytree::Transfer
    has_many :reverse_payouts

    validates_numericality_of :amount, greater_than: 0

    def execute!
      process_response(
        payment_gateway.payout(customer_transaction.details, amount, metadata: {moneytree_transfer_id: id})
      )
    end
  end
end
