module Moneytree
  module PaymentProvider
    class StripeMarketplace < Base
      def initialize
        ::Stripe.api_key = Moneytree.stripe_credentials[:api_key]
      end

      def prepare_payment(amount, transfers, metadata: {}, description: "Charge for #{account.name}")
        payment_intent = Stripe::PaymentIntent.create(
          {
            amount: (amount * 100).to_i,
            currency: Moneytree.marketplace_currency,
            payment_method_types: ['card'],
            metadata: metadata
          }
        )

        transfers.each do |transfer|
          transfer = Stripe::Transfer.create(
            {
              amount: transfer.amount,
              currency: transfer.payment_gateway.account.currency_code,
              destination: transfer.payment_gateway.psp_credentials['account_id'],
              source_transaction: payment_intent.id,
              metadata: { moneytree_transfer_id: transfer.id }
            }
          )
        end

        # succeeded, pending, or failed
        Moneytree::TransactionResponse.new(
          { succeeded: :success, pending: :pending, failed: :failed }[payment_intent.status.to_sym],
          payment_intent.failure_message,
          { payment_intent_id: payment_intent.id }
        )
      rescue ::Stripe::StripeError => e
        Moneytree::TransactionResponse.new(:failed, e.message)
      end

      def fetch_status(_details)
        payment_intent = ::Stripe::PaymentIntent.retrieve(details['payment_intend_id'])

        Moneytree::TransactionResponse.new(
          {
            succeeded: :success,
            requires_payment_method: :initialized,
            requires_confirmation: :initialized,
            requires_action: :pending,
            processing: :pending,
            canceled: :failed
          }[payment_intent.status.to_sym],
          payment_intent.failure_message,
          {
            charge_id: payment_intent.id,
            has_application_fee: !app_fee_amount.zero?
          }
        )
      end
    end
  end
end
