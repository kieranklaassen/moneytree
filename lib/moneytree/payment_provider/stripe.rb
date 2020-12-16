module Moneytree
  module PaymentProvider
    class Stripe < Base
      # The permissions we request from Square OAuth, we store them in the database
      PERMISSION = :read_write

      def initialize(payment_gateway)
        raise Error, 'Please set your Stripe credentials' if credentitals.nil?
        raise Error, 'Please include the stripe gem to your Gemfile' unless Object.const_defined?('::Stripe')

        ::Stripe.api_key = credentitals[:api_key]
        super
      end

      def onboarding_url(moneytree_account, current_host)
        if payment_gateway.psp_credentials&.dig(:account_id)
          stripe_account = ::Stripe::Account.retrieve(payment_gateway.psp_credentials[:account_id])
        else
          stripe_account = ::Stripe::Account.create({
            type: 'express',
            capabilities: { card_payments: { requested: true }, transfers: { requested: true } },
            metadata: { payment_gateway_id: payment_gateway.id, account_id: moneytree_account.id, account_type: moneytree_account.class.name }
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

      def get_access_token(params)
        # FIXME: add error handling
        ::Stripe::OAuth.token(
          {
            grant_type: 'authorization_code',
            code: params[:code]
          }
        ).to_hash
      end

      def scope
        PERMISSION.to_s
      end

      def charge(amount, details, metadata:, app_fee_amount: 0, description: "Charge for #{account.name}")
        # `source` is obtained with Stripe.js; see https://stripe.com/docs/payments/accept-a-payment-charges#web-create-token
        response = ::Stripe::Charge.create(
          {
            amount: (amount * 100).to_i,
            currency: account.currency_code,
            source: details[:card_token],
            description: description,
            metadata: metadata,
            application_fee_amount: (app_fee_amount * 100).to_i
          },
          stripe_account: payment_gateway.psp_credentials[:stripe_user_id]
        )
        # succeeded, pending, or failed
        Moneytree::TransactionResponse.new(
          { succeeded: :success, pending: :pending, failed: :failed }[response[:status].to_sym],
          response[:failure_message],
          {
            charge_id: response[:id],
            card: response[:payment_method_details][:card],
            has_application_fee: !app_fee_amount.zero?
          }
        )
      rescue ::Stripe::StripeError => e
        Moneytree::TransactionResponse.new(:failed, e.message)
      end

      def refund(amount, details, metadata:)
        response = ::Stripe::Refund.create(
          {
            charge: details[:charge_id],
            amount: (-amount * 100).to_i,
            metadata: metadata,
            refund_application_fee: details[:has_application_fee] && Moneytree.refund_application_fee
          },
          stripe_account: payment_gateway.psp_credentials[:stripe_user_id]
        )

        # succeeded, pending, or failed
        Moneytree::TransactionResponse.new(
          { succeeded: :success, pending: :pending, failed: :failed }[response[:status].to_sym],
          response[:failure_message],
          { refund_id: response[:id] }
        )
      rescue ::Stripe::StripeError => e
        Moneytree::TransactionResponse.new(:failed, e.message)
      end

      def card_for(transaction)
        Moneytree::Card.new(
          last4: transaction.details[:card][:last4],
          exp_month: transaction.details[:card][:exp_month],
          exp_year: transaction.details[:card][:exp_year],
          fingerprint: transaction.details[:card][:fingerprint],
          brand: transaction.details[:card][:brand],
          address_zip: transaction.details[:card][:address_zip],
          country: transaction.details[:card][:country]
        )
      end

      private

      def credentitals
        Moneytree.stripe_credentials
      end
    end
  end
end
