module Moneytree
  class ReversePayout < Moneytree::Transfer
    belongs_to :payout

    before_validation :set_account_order, :set_payment_gateway

    validates_numericality_of :amount, less_than: 0

    def execute!
      process_response(
        payment_gateway.reverse_payout(payout.details, -amount, metadata: { moneytree_transfer_id: id })
      )
    end

    def set_account_order
      self.account_order = payout.account_order
    end

    def set_payment_gateway
      self.payment_gateway = payout.payment_gateway
    end
  end
end
