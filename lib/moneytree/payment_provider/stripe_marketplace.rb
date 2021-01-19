module Moneytree
  module PaymentProvider
    class StripeMarketplace < Base
      class << self
        def prepare_payment(amount, transfers, metadata: {}, description: "Charge for #{transfers.map(&:account_name).join(', ')}")
          ::Stripe.api_key = Moneytree.stripe_credentials[:api_key]

          payment_intent = ::Stripe::PaymentIntent.create(
            {
              amount: (amount * 100).to_i,
              currency: Moneytree.marketplace_currency,
              payment_method_types: ['card'],
              metadata: metadata
            }
          )

          # succeeded, pending, or failed
          Moneytree::PspResponse.new(
            {
              succeeded: :success,
              requires_payment_method: :initialized,
              requires_confirmation: :initialized,
              requires_action: :pending,
              processing: :pending,
              canceled: :failed
            }[payment_intent.status.to_sym],
            payment_intent[:failure_message],
            {
              payment_intent_id: payment_intent.id,
              client_secret: payment_intent.client_secret
            }
          )
        rescue ::Stripe::StripeError => e
          Moneytree::PspResponse.new(:failed, e.message)
        end

        def cancel_payment(details)
          ::Stripe::PaymentIntent.retrieve(details[:payment_intent_id]).cancel
        end

        def fetch_status(details, app_fee_amount)
          payment_intent = ::Stripe::PaymentIntent.retrieve(details[:payment_intent_id])
          Moneytree::PspResponse.new(
            {
              succeeded: :success,
              requires_payment_method: :initialized,
              requires_confirmation: :initialized,
              requires_action: :pending,
              processing: :pending,
              canceled: :failed
            }[payment_intent.status.to_sym],
            payment_intent[:failure_message],
            {
              charge_id: payment_intent.charges.detect { |c| c.status == 'succeeded' }.id,
              has_application_fee: !!app_fee_amount&.nonzero?
            }
          )
        end
      end

      def initialize(_payment_gateway)
        ::Stripe.api_key = Moneytree.stripe_credentials[:api_key]

        super
      end

      def onboarding_url(payment_gateway, moneytree_account, current_host)
        if payment_gateway.psp_credentials&.dig(:account_id)
          stripe_account = ::Stripe::Account.retrieve(payment_gateway.psp_credentials[:account_id])
        else
          stripe_account = ::Stripe::Account.create({
            type: 'express',
            capabilities: { card_payments: { requested: true }, transfers: { requested: true } },
            metadata: { moneytree_payment_gateway_id: payment_gateway.id, account_id: moneytree_account.id, account_type: moneytree_account.class.name }
          }.merge(moneytree_account.moneytree_onboarding_data))

          payment_gateway.update! psp_credentials: { account_id: stripe_account.id }
        end

        stripe_account_link = ::Stripe::AccountLink.create(
          {
            account: stripe_account.id,
            refresh_url: Moneytree::Engine.routes.url_helpers.onboarding_stripe_new_url(host: current_host),
            return_url: Moneytree::Engine.routes.url_helpers.onboarding_stripe_complete_url(host: current_host),
            type: 'account_onboarding'
          }
        )

        stripe_account_link.url
      end

      def retrieve_account(id)
        ::Stripe::Account.retrieve(id)
      end

      def payout(payment_details, amount, metadata: {})
        response = ::Stripe::Transfer.create(
          amount: (amount * 100).to_i,
          currency: payment_gateway.account.currency_code,
          destination: payment_gateway.psp_credentials[:account_id],
          source_transaction: payment_details[:charge_id],
          metadata: metadata
        )

        Moneytree::PspResponse.new(:success, '', { transfer_id: response.id })
      rescue ::Stripe::StripeError => e
        Moneytree::PspResponse.new(:failed, e.message)
      end

      def reverse_payout(payout_details, amount, metadata: {})
        response = ::Stripe::Transfer.create_reversal(payout_details[:transfer_id], {
          amount: (amount * 100).to_i,
          metadata: metadata
        })

        Moneytree::PspResponse.new(:success, '', { transfer_id: response.id })
      rescue ::Stripe::StripeError => e
        Moneytree::PspResponse.new(:failed, e.message)
      end

      def scope; end
    end
  end
end
