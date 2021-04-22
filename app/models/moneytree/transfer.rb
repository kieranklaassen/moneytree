module Moneytree
  class Moneytree::Transfer < ApplicationRecord
    belongs_to :payment_gateway
    belongs_to :account_order, polymorphic: true
    belongs_to :customer_transaction, foreign_key: :transaction_id, class_name: "Moneytree::Transaction", optional: true

    enum status: %i[initialized completed failed]

    serialize :details

    scope :payout, -> { where(type: "Moneytree::Payout") }
    scope :reverse_payout, -> { where(type: "Moneytree::ReversePayout") }

    def account_name
      payment_gateway.account.name
    end

    # @param [PspResponse] response
    def process_response(response)
      if response.success?
        update!(
          status: :completed,
          details: (details || {}).merge(response.body)
        )
      else
        update!(
          status: :failed,
          psp_error: response.message
        )
      end
    end
  end
end
