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
