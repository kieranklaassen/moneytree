module Moneytree
  class Refund < Moneytree::Transaction
    belongs_to :payment, class_name: "Moneytree::Payment"

    before_validation :set_order, :set_payment_gateway

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
          metadata: metadata.merge(moneytree_transaction_id: id)
        )
      )
    end

    # validates_presence_of :payment
    def set_order
      self.order ||= payment&.order
    end

    # validates_presence_of :payment
    def set_payment_gateway
      self.payment_gateway ||= payment&.payment_gateway
    end

    # validates
    def order_matches_payment
      errors.add(:order_id, :mismatch) if order_id != payment&.order_id
    end

    # validates
    def gateway_matches_payment
      errors.add(:payment_gateway_id, :mismatch) if payment_gateway_id != payment&.payment_gateway_id
    end
  end
end
