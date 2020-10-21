module Moneytree
  class Transaction < ApplicationRecord
    belongs_to :payment_gateway
    belongs_to :order, polymorphic: true

    enum kind: %i[payment refund]
    enum status: %i[initialized processing completed failed]
    # FIXME: add all validation and logic stuff here :)

    serialize :details

    after_create_commit :execute_transaction

    private

    def execute_transaction
      result =
        if payment?
          payment_gateway.charge(amount, app_fee_amount)
        else
          payment_gateway.refund(-amount, -app_fee_amount)
        end

      if result.success?
        completed!
      else
        update(
          status: :failed,
          psp_error: result.error
        )
      end
    end
  end
end
