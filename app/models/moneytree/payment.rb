module Moneytree
  class Payment < Moneytree::Transaction
    has_many :refunds, class_name: 'Moneytree::Refund'

    validates_absence_of :payment_id

    validates_numericality_of :amount, greater_than: 0
    validates_numericality_of :app_fee_amount, greater_than_or_equal_to: 0

    private

    # TODO: Expose description to user
    def prepare_transaction
      response = Moneytree.marketplace_provider.prepare_payment(
        amount,
        transfers,
        metadata: metadata.merge(moneytree_transaction_id: id)
      )

      update!(
        status: :pending,
        details: response.body
      )
    end

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

    def fetch_status!
      raise Moneytree::Error, 'Cannot fetch status on direct transaction' unless marketplace?
      return if completed? || failed?

      Moneytree.marketplace_provider.fetch_status(details)
    end
  end
end
