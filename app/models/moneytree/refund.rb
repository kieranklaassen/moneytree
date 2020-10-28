module Moneytree
  class Refund < Transaction
    belongs_to :payment, class_name: 'Moneytree::Payment'

    validates_presence_of :payment

    validates_numericality_of :amount, less_than: 0
    validates_numericality_of :app_fee_amount, less_than_or_equal_to: 0

    validate :order_matches_payment, :gateway_matches_payment

    private

    def execute_transaction(metadata: {})
      process_response(
        payment_gateway.refund(
          amount,
          payment.details,
          refund_reason,
          metadata: metadata.merge(moneytree_transaction_id: id)
        )
      )
    end

    # validates
    def order_matches_payment
      errors.add(:order_id, :mismatch) if order_id != payment&.order_id
    end

    # validates
    def order_matches_payment
      errors.add(:payment_gateway_id, :mismatch) if payment_gateway_id != payment&.payment_gateway_id
    end
  end
end
