require 'test_helper'

module Moneytree
  class PaymentGatewayTest < ActiveSupport::TestCase
    setup do
      @account = Merchant.create name: 'Mr Boomtown'
      @payment_gateway = @account.create_moneytree_payment_gateway(psp: :stripe)
      Moneytree.stripe_credentials = Rails.application.credentials.stripe
    end

    test 'has one Account' do
      assert_equal @payment_gateway.account.class, Merchant
    end

    test 'has no connected stripe account' do
      assert_equal @payment_gateway.oauth_link, 'https://connect.stripe.com/oauth/authorize?client_id=ca_I1PszKbm15ZwqDeQJFdW2SU99j33rbPs&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fmt%2Foauth%2Fstripe%2Fcallback&response_type=code&scope=read_write&stripe_user%5Bcurrency%5D=USD&stripe_user%5Bemail%5D=test%40example.com&stripe_user%5Burl%5D=https%3A%2F%2Fwww.example.com'
      refute @payment_gateway.psp_connected?
      assert @payment_gateway.needs_oauth?
      refute @payment_gateway.scope_correct?
    end

    test 'has a connected stripe account' do
      @payment_gateway.psp_credentials = {
        scope: 'read_write',
        access_token: '',
        refresh_token: '',
        stripe_user_id: '',
        stripe_publishable_key: ''
      }

      assert @payment_gateway.psp_connected?
      refute @payment_gateway.needs_oauth?
      assert @payment_gateway.scope_correct?
    end
  end
end
