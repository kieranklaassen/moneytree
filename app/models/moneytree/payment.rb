module Moneytree
  class Payment < Moneytree::Transaction
    has_many :refunds, class_name: 'Moneytree::Refund'

    validates_absence_of :payment_id

    validates_numericality_of :amount, greater_than: 0
    validates_numericality_of :app_fee_amount, greater_than_or_equal_to: 0, allow_nil: true

    before_destroy :cancel_payment

    # TODO: Make state machine logic
    after_save :execute_payouts, if: -> { saved_change_to_status? && completed? }

    def fetch_status!
      raise Moneytree::Error, 'Cannot fetch status on direct transaction' unless marketplace?
      return if completed? || failed?

      process_response Moneytree.marketplace_provider.fetch_status(details, app_fee_amount)
    end

    private

    # TODO: Expose description to user
    def prepare_transaction
      response = Moneytree.marketplace_provider.prepare_payment(
        amount,
        transfers,
        metadata: { moneytree_transaction_id: id }
      )

      process_response(response)
    end

    def cancel_payment
      throw :abort unless initialized?
      throw :abort if refunds.any?

      transfers.each(&:destroy!)
      Moneytree.marketplace_provider.cancel_payment(details)
    end

    def execute_transaction
      process_response(
        payment_gateway.charge(
          amount,
          details,
          app_fee_amount: app_fee_amount,
          metadata: { moneytree_transaction_id: id }
        )
      )
    end

    def execute_payouts
      transfers.initialized.each(&:execute!)
    end
  end
end
