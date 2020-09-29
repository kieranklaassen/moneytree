# dependencies
# require 'rails'
# require 'active_support/core_ext'

# modules
# FIXME: autoload instead? https :/ / github.com / excid3 / noticed / blob / master / lib / noticed.rb
require 'moneytree/version'
require 'moneytree/account'
require 'moneytree/payment_provider/base'
require 'moneytree/payment_provider/stripe'
require 'moneytree/engine'

module Moneytree
  PSPS = %i[stripe].freeze

  mattr_accessor :enabled_psps
  mattr_accessor :stripe_credentials
  mattr_accessor :current_account
  mattr_accessor :oauth_redirect

  @@enabled_psps = PSPS
  @@current_account = :current_account
  @@oauth_redirect = '/'

  def self.setup
    yield self
  end

  # Errors FIXME: see examples at https://github.com/pay-rails/pay/blob/master/lib/pay.rb#L119
  class Error < StandardError; end
end

# FIXME: See if we need this
ActiveSupport.on_load(:action_controller) do
  # include Moneytree::Controller
end

ActiveSupport.on_load(:active_record) do
  # extend Moneytree::Model
end

ActiveSupport.on_load(:action_view) do
  # include Moneytree::Helper
end
