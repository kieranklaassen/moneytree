Moneytree.setup do |config|
  config.enabled_psps = %i[square stripe braintree]

  # Account, merchant, team, Payee etc.
  config.account_class = 'Account'
  config.account_table = 'accounts'

  # Order
  config.order_class = 'Order'
  config.order_table = 'orders'

  # Transaction
  config.transaction_class = 'Transaction'
  config.transaction_table = 'transactions'
end
