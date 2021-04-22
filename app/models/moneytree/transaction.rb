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

    scope :payment, -> { where(type: "Moneytree::Payment") }
    scope :refund, -> { where(type: "Moneytree::Refund") }

    def payment?
      is_a? Moneytree::Payment
    end

    def refund?
      is_a? Moneytree::Refund
    end

    def marketplace?
      transfers.any?
    end

    def card
      payment_provider.card_for(self)
    end

    # @param [PspResponse] response
    def process_response(response)
      case response.status
      when :initialized, :pending
        update!(
          status: response.status,
          details: (details || {}).merge(response.body)
        )
      when :success
        update!(
          status: :completed,
          details: (details || {}).merge(response.body)
        )
      when :failed
        update!(
          status: :failed,
          psp_error: response.message
        )
      end

      if Moneytree.order_status_trigger_method && saved_change_to_status?
        order.send(Moneytree.order_status_trigger_method, self)
      end
    end
  end
end
