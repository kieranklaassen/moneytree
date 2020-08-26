# dependencies
require 'active_support'
require 'active_support/core_ext'

# modules
require 'moneytree/version'

require "'moneytree/engine" if defined?(Rails)

module Moneytree
  mattr_accessor :enabled_psps
  self.enabled_psps = %i[square stripe braintree]

  mattr_accessor :account_class
  self.account_class = 'Account'
  mattr_accessor :account_table
  self.account_table = account_class.tableize

  mattr_accessor :order_class
  self.order_class = 'Order'
  mattr_accessor :order_table
  self.order_table = order_class.tableize

  mattr_accessor :transaction_class
  self.transaction_class = 'Transaction'
  mattr_accessor :transaction_table
  self.transaction_table = transaction_class.tableize

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
