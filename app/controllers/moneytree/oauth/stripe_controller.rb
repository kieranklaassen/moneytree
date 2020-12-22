module Moneytree
  module Oauth
    class StripeController < Moneytree::ApplicationController
      def new
        redirect_to stripe_oauth_url
      end

      def callback
        # TODO: Remove this module prefix once we figure out how to properly autoload this.
        payment_gateway = __current_account.create_moneytree_payment_gateway(psp: 'stripe')
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
            scope: Moneytree::PaymentProvider::Stripe::PERMISSION,
            redirect_uri: oauth_stripe_callback_url,
            'stripe_user[email]': __current_account.email,
            'stripe_user[url]': __current_account.website,
            'stripe_user[currency]': __current_account.currency_code
          }.to_query
        ).to_s
      end
    end
  end
end
