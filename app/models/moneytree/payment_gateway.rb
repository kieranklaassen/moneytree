module Moneytree
  class PaymentGateway < ApplicationRecord
    belongs_to :account, polymorphic: true

    enum psp: Moneytree::PSPS
    serialize :psp_credentials
    # encrypts :psp_credentials
    # FIXME: enable https://github.com/ankane/lockbox
    delegate :oauth_link, :scope_correct?, :charge, :refund, to: :payment_provider

    has_many :transactions

    def oauth_callback(params)
      update! psp_credentials: payment_provider.get_access_token(params)
      account.send(:moneytree_oauth_callback) if account.respond_to?(:moneytree_oauth_callback, true)
    end

    def psp_connected?
      psp.present? && psp_credentials.present?
    end

    def needs_oauth?
      !psp_connected? || !scope_correct?
    end

    def scope_correct?
      psp_credentials[:scope] == payment_provider.scope
    end

    def payment_provider
      @payment_provider ||=
        case psp
        when 'stripe'
          # TODO: see if we only need to pass credentials
          Moneytree::PaymentProvider::Stripe.new(self)
        # when 'square'
        #   Moneytree::PaymentProvider::Square.new(self)
        else
          raise 'BOOM'
        end
    end
  end
end
