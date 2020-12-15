module Moneytree
  module Onboarding
    class StripeController < Moneytree::ApplicationController

      def new
        payment_gateway = current_account.create_moneytree_payment_gateway!(
          psp: 'stripe',
          marketplace_capable: true
        )

        ::Stripe.api_key = Moneytree.stripe_credentials[:api_key]

        account = ::Stripe::Account.create({
          type: 'express',
          capabilities: { card_payments: { requested: true }, transfers: { requested: true } },
          metadata: { moneytree_id: payment_gateway.id }
        }.merge(account_prefill_data))

        payment_gateway.update! psp_credentials: { account_id: account.id }

        session[:account_id] = account.id
        redirect_to onboarding_stripe_onboard_path
      end

      def onboard
        account_link = Stripe::AccountLink.create(
          {
            account: session[:account_id],
            refresh_url: onboarding_stripe_onboard_url,
            return_url: Moneytree.oauth_redirect,
            type: 'account_onboarding'
          }
        )

        redirect_to account_link.url
      end

      private

      def account_prefill_data
        current_account.moneytree_onboarding_data
      end

      def current_account
        send(Moneytree.current_account)
      end
    end
  end
end
