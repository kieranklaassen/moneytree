module Moneytree
  class PaymentGateway < ApplicationRecord
    include Moneytree::Account

    belongs_to :account, polymorphic: true

    enum moneytree_psp: Moneytree::PSPS
    serialize :psp_credentials
    # encrypts :psp_credentials
    # FIXME: enable https://github.com/ankane/lockbox
    delegate :oauth_link, :scope_correct?, to: :psp

    # has_many :orders
    # has_many :transactions
    # has_many :customers
    # has_many :cards

    def oauth_callback(params)
      update! psp_credentials: psp.get_access_token(params)
    end

    def psp_connected?
      moneytree_psp && psp_credentials
    end

    def needs_oauth?
      !psp_connected? || !scope_correct?
    end

    def charge; end

    def refund; end

    private

    def psp
      @psp ||=
        case moneytree_psp
        when 'stripe'
          Moneytree::PaymentProvider::Stripe.new(self)
        # when 'square'
        #   Moneytree::PaymentProvider::Square.new(self)
        else
          raise 'BOOM'
        end
    end
  end
end
