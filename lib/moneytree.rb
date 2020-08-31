# dependencies
require 'active_support'
require 'active_support/core_ext'

# modules
# FIXME: autoload instead? https :/ / github.com / excid3 / noticed / blob / master / lib / noticed.rb
require 'moneytree/version'
require 'moneytree/account'
require 'moneytree/transaction'
require 'moneytree/payment_provider/square'

require "'moneytree/engine" if defined?(Rails)

module Moneytree
  PSPS = %i[square stripe braintree].freeze

  mattr_accessor :enabled_psps
  mattr_accessor :account_class
  mattr_accessor :order_class
  mattr_accessor :transaction_class
  mattr_accessor :square_credentials

  @@enabled_psps = PSPS
  @@account_class = 'Account'
  @@order_class = 'Order'
  @@transaction_class = 'Transaction'

  def self.setup
    yield self
  end

  # Errors FIXME: see examples at https://github.com/pay-rails/pay/blob/master/lib/pay.rb#L119
  class Error < StandardError; end
end

# FIXME: See if we need this, example: https://github.com/ankane/ahoy/blob/master/lib/ahoy/model.rb
ActiveSupport.on_load(:action_controller) do
  # include Moneytree::Controller
end

ActiveSupport.on_load(:active_record) do
  # extend Moneytree::Model
end

ActiveSupport.on_load(:action_view) do
  # include Moneytree::Helper
end
