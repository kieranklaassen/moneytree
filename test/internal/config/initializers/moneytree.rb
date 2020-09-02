Moneytree.setup do |config|
  config.enabled_psps = %i[square stripe braintree]

  config.account_class = 'Account'
  config.order_class = 'Order'
  config.transaction_class = 'Transaction'

  config.square_credentials = {
    app_id: 'app_id',
    app_secret: 'token',
    environment: 'sandbox',
    oauth_domain: 'https://connect.squareupsandbox.com'
  }
end
