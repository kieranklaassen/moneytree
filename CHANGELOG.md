## Master

- Add authentication settings
- Add onboarding of Stripe Express accounts using the Stripe Connect API
- NOTE: Migrations have changed. Make sure to reflect this in your app. If you're upgrading at this point, create a migration with the following statements:

```ruby
    add_column :moneytree_payment_gateways, :onboarding_completed, :boolean, null: false, default: false
    add_column :moneytree_payment_gateways, :marketplace_capable, :boolean, null: false, default: false
    change_column_null :moneytree_transactions, :app_fee_amount, true
    change_column_default :moneytree_transactions, :app_fee_amount, from: 0.0, to: nil
    change_column_null :moneytree_transactions, :payment_gateway_id, true
```

## 0.1.11 (2020-12-10)

- Keep track of whether an application fee was charged

## 0.1.10 (2020-11-27)

- Add Card object for transactions

## 0.1.9 (2020-11-27)

- Fix all implicit constants in /app

## 0.1.8 (2020-11-27)

- Fix a bug causing Moneytree to crash on payment

## 0.1.7 (2020-11-27)

- Add `Moneytree::PaymentGateway#transactions`

## 0.1.6 (2020-11-27)

- Add support for account-based callbacks on OAuth2 authentication completion

## 0.1.5 (2020-11-27)

- Fix an autoloading issue causing Moneytree to conflict with your own Rails app if you have a model called `PaymentGateway`

## 0.1.4 (2020-11-04)

- Add `Moneytree::Order` concern that links transactions and enables payments
- Add charge and refund capabilities
- Add webhooks

## 0.1.3 (2020-10-08)

- Fix account to be `null: true` since it is a has_one relation

## 0.1.2 (2020-09-29)

- Add `oauth_redirect` setting to set a custom path to return after the OAuth flow

## 0.1.1 (2020-09-28)

- Add Stripe OAuth flow
- Add Payment Gateway model

## 0.1.0 (2020-09-02)

- Initial release that is work in progress
