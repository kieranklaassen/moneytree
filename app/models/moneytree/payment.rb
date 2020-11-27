module Moneytree
  class Payment < Moneytree::Transaction
    has_many :refunds, class_name: 'Moneytree::Refund'

    validates_absence_of :payment_id

    validates_numericality_of :amount, greater_than: 0
    validates_numericality_of :app_fee_amount, greater_than_or_equal_to: 0

    private

    def execute_transaction(metadata: {})
      process_response(
        payment_gateway.charge(
          amount,
          details,
          app_fee_amount: app_fee_amount,
          metadata: metadata.merge(moneytree_transaction_id: id)
        )
      )
    end
  end
end
