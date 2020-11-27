## Master

## 0.1.9

- Fix all implicit constants in /app

## 0.1.8

- Fix a bug causing Moneytree to crash on payment

## 0.1.7

- Add `Moneytree::PaymentGateway#transactions`

## 0.1.6

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
