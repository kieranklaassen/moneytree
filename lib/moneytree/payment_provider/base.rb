module Moneytree
  module PaymentProvider
    class Base
      def initialize(account)
        @account = account
      end
    end
  end
end
