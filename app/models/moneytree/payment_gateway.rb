module Moneytree
  class PaymentGateway < ApplicationRecord
    include Moneytree::Account

    belongs_to :account, polymorphic: true

    enum moneytree_psp: Moneytree::PSPS
    serialize :psp_credentials
    # encrypts :psp_credentials
    # FIXME: enable https://github.com/ankane/lockbox
    delegate :client, :oauth_link, to: :psp

    # has_many :orders
    # has_many :transactions
    # has_many :customers
    # has_many :cards

    def oauth_callback(params)
      update! psp_credentials: psp.oauth_callback(params)
    end

    def psp_connected?
      false
      # moneytree_psp && psp_credentials
    end

    def needs_oauth?
      true
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
