class RefundsController < ApplicationController
  # POST /refunds
  def create
    # FIXME:
    @refund = Moneytree::Refund.new(refund_params)

    if @refund.save
      redirect_to @refund.order, notice: "Refund was successfully created."
    else
      redirect_to @refund.order, notice: @refund.errors.full_messages
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def refund_params
    params.require(:refund).permit(:payment_id, :amount, :refund_reason)
  end
end
