require 'test_helper'

module Moneytree
  class AccountTest < ActiveSupport::TestCase
    setup do
      @account = Merchant.create name: 'Mr Boomtown'
      @payment_gateway = Moneytree::PaymentGateway.create(account: @account, moneytree_psp: :stripe)
    end

    test 'has one PaymentGateway and vice versa' do
      assert_equal @account.payment_gateway.class, Moneytree::PaymentGateway
      assert_equal @payment_gateway.account.class, Merchant
    end
  end
end
