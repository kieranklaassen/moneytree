module Moneytree
  module PaymentProvider
    class Base
      attr_reader :payment_gateway, :account

      def initialize(payment_gateway)
        @payment_gateway = payment_gateway
        @account = @payment_gateway.account
      end
    end
  end
end
