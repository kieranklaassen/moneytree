module Moneytree
  class Payment < Transaction
    # FIXME: add all validation and logic stuff here :)

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
