module Moneytree
  module Account
    extend ActiveSupport::Concern

    included do
      enum moneytree_psp: Moneytree.psps
      serialize :psp_credentials
      # encrypts :psp_credentials
      # FIXME: enable https://github.com/ankane/lockbox
    end
  end
end
