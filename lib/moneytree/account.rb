module Moneytree
  module Account
    extend ActiveSupport::Concern

    included do
      enum moneytree_psp: Moneytree::PSPS
      serialize :psp_credentials
      # encrypts :psp_credentials
      # FIXME: enable https://github.com/ankane/lockbox
      delegate :client, :oauth_link, to: :psp
    end

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
        when 'square'
          Moneytree::PaymentProvider::Square.new(self)
        else
          raise 'BOOM'
        end
    end
  end
end
