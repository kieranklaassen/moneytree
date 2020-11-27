module Moneytree
  class Transaction < Moneytree::ApplicationRecord
    belongs_to :payment_gateway
    belongs_to :order, polymorphic: true

    validates_presence_of :psp_error, if: :failed?

    enum status: %i[initialized pending completed failed]

    serialize :details

    delegate :payment_provider, to: :payment_gateway

    after_create_commit :execute_transaction

    def card
      payment_provider.card_for(self)
    end

    def process_response(response)
      if response.success?
        update!(
          status: :completed,
          psp_error: response.message,
          details: (details || {}).merge(response.body)
        )
      else
        # FIXME: pending state
        update!(
          status: :failed,
          psp_error: response.message
        )
      end
    end
  end
end
