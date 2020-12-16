module Moneytree
  module Onboarding
    class StripeController < Moneytree::ApplicationController
      def new
        payment_gateway = Moneytree::PaymentGateway.find_or_create_by!(
          id: session[:payment_gateway_id],
          psp: 'stripe',
          marketplace_capable: true
        )

        session[:payment_gateway_id] = payment_gateway.id

        redirect_to payment_gateway.onboarding_url(current_account, request.base_url)
      end

      def complete
        payment_gateway = Moneytree::PaymentGateway.find(session[:payment_gateway_id])
        account = ::Stripe::Account.retrieve(payment_gateway[:psp_credentials][:account_id])
        payment_gateway.update!(onboarding_completed: account.details_submitted)

        redirect_to Moneytree.oauth_redirect
      end
    end
  end
end
