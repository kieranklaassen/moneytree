module Moneytree
  module StripeConfirmable
    extend ActiveSupport::Concern

    def confirm_stripe_account(payment_gateway, stripe_account)
      payment_gateway.update!(
        onboarding_completed: stripe_account.details_submitted,
        psp_credentials: payment_gateway.psp_credentials.merge({ stripe_account: stripe_account })
      )

      # Attach this payment gateway to this account
      stripe_account
        .metadata.account_type.constantize
        .find(stripe_account.metadata.account_id)
        .update!(moneytree_payment_gateway: payment_gateway)
    end
  end
end
