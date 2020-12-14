require 'active_support/concern'

module Moneytree
  module Account
    extend ActiveSupport::Concern
    # FIXME: see if we can remove  config.current_account = :current_merchant and set it from here

    included do
      has_one :moneytree_payment_gateway, class_name: 'Moneytree::PaymentGateway', foreign_key: 'account_id', inverse_of: :account, as: :account
    end

    # Can be overridden by your Account class. Returns data that can be used to prefill the
    # onboarding form from a PSP.
    #
    # @return [Hash]
    def onboarding_data
      {
        business_type: 'company',
        country: 'US',
        email: 'user@example.com',
        company: {
          name: 'User Example LLC',
          address: {
            line1: '1 N State St',
            line2: '',
            postal_code: '60602',
            city: 'Chicago',
            state: 'IL',
            country: 'US'
          },
          phone: '+17735551234',
          structure: 'multi_member_llc',
          tax_id: '980000000'
        }
      }
    end
  end
end
