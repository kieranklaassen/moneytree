module Moneytree
  module Oauth
    class StripeController < ApplicationController
      def new
        redirect_to stripe_oauth_url
      end

      def callback
        payment_gateway = PaymentGateway.create!(psp: 'stripe', account: current_account)
        payment_gateway.oauth_callback(payment_gateway_params)
        redirect_to Moneytree.oauth_redirect, notice: 'Connected to Stripe'
      end

      private

      def payment_gateway_params
        params.permit :scope, :code
      end

      def stripe_oauth_url
        # https://stripe.com/docs/connect/oauth-reference
        # https://stripe.com/docs/connect/oauth-reference#get-authorize
        URI::HTTPS.build(
          host: 'connect.stripe.com',
          path: '/oauth/authorize',
          query: {
            response_type: :code,
            client_id: Moneytree.stripe_credentials[:client_id],
            scope: PaymentProvider::Stripe::PERMISSION,
            redirect_uri: oauth_stripe_callback_url, # FIXME: use rails url helper and add host
            'stripe_user[email]': current_account.email,
            'stripe_user[url]': current_account.website,
            'stripe_user[currency]': current_account.currency_code
          }.to_query
        ).to_s
      end

      def current_account
        send(Moneytree.current_account)
      end
    end
  end
end
