module Moneytree
  class Transaction < ApplicationRecord
    belongs_to :payment_gateway
    belongs_to :order, polymorphic: true

    enum kind: %i[payment refund]
    enum status: %i[initialized pending completed failed]
    # FIXME: add all validation and logic stuff here :)

    serialize :details

    after_create_commit :execute_transaction

    private

    def execute_transaction(metadata: {})
      result =
        if payment?
          payment_gateway.charge(
            amount,
            details,
            app_fee_amount: app_fee_amount,
            metadata: metadata.merge(moneytree_transaction_id: id)
          )
        else
          payment_gateway.refund(-amount, -app_fee_amount, details)
        end

      if result.success?
        completed!
      else
        # FIXME: pending state
        update(
          status: :failed,
          psp_error: result.message
        )
      end
    end
  end
end
