module Moneytree
  class Transaction < ApplicationRecord
    self.abstract_class = true
    self.table_name = 'moneytree_transactions'

    belongs_to :payment_gateway
    belongs_to :order, polymorphic: true

    validates_presence_of :psp_error, if: :failed?

    enum status: %i[initialized pending completed failed]

    serialize :details

    after_create_commit :execute_transaction

    private

    def process_response(response)
      if response.success?
        update(
          status: :completed,
          psp_error: response.message,
          details: details.merge(response.body)
        )
      else
        # FIXME: pending state
        update(
          status: :failed,
          psp_error: respose.message
        )
      end
    end
  end
end
