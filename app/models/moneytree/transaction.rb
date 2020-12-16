module Moneytree
  class Transaction < Moneytree::ApplicationRecord
    belongs_to :payment_gateway, optional: true
    belongs_to :order, polymorphic: true

    has_many :transfers

    validates_presence_of :psp_error, if: :failed?
    validates_presence_of :payment_gateway, unless: :marketplace?
    validates_presence_of :transfers, unless: :payment_gateway

    validates_presence_of :app_fee_amount, if: :payment_gateway
    validates_absence_of :app_fee_amount, if: :marketplace?

    enum status: %i[initialized pending completed failed]

    serialize :details

    delegate :payment_provider, to: :payment_gateway

    after_create_commit :execute_transaction, if: :payment_gateway
    after_create_commit :prepare_transaction, if: :marketplace?

    def marketplace?
      transfers.any?
    end

    def card
      payment_provider.card_for(self)
    end

    def process_response(response)
      if response.success?
        update!(
          status: :completed,
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
