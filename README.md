# 🚧 WORK IN PROGRESS 🚧

- [ ] OAuth
  - [ ] Controller actions
  - [ ] Scopes
  - [ ] Square
  - [ ] Stripe
  - [ ] Braintree
- [ ] Moneytree models
  - [ ] Payment gateway, belongs to account
  - [ ] Cards
  - [ ] Customers
  - [ ] Payments
  - [ ] Refunds
- [ ] Notifications

# Moneytree 💵 🌴

[![Actions Status](https://github.com/kieranklaassen/moneytree/workflows/build/badge.svg)](https://github.com/kieranklaassen/moneytree/actions)
[![Gem Version](https://badge.fury.io/rb/moneytree-rails.svg)](https://badge.fury.io/rb/moneytree-rails)

🔥 A powerful, simple, and extendable payment engine for rails, centered around transactional payments. 💵 🌴

Moneytree is a rails engine to add multi-PSP payments to your app by extending your own models. It brings the following
functionality with almost no work on your end:

- 💵💶💷💴 Multi-currency
- 🔑 OAuth to link your PSP account
- 👩‍💻PSP account creation, (with commission)
- ⚙️ Webhooks
- 💳 PCI compliance with Javascript libraries
- 🧲 Platform fees

Currently we support the following PSP's:

- Square
- Stripe
- Braintree

But if you want to add more PSP's, we make it easy to do so. Read our
[Contributing](https://github.com/kieranklaassen/moneytree#contributing) section to learn more.

## Installation

### Easy Installation

Run our installer script:

```bash
rails app:template LOCATION='https://railsbytes.com/script/Xg8sOv'
```

### Manual Installation

Add the latest version of Moneytree to your gem Gemfile by running:

```bash
$ bundle add moneytree-rails
$ bundle install
$ bundle exec moneytree init
```

Or your can use environment variables:

FIXME: add

## Configuration

Do you need to make some changes to how Moneytree is used? You can create an initializer
`config/initializers/moneytree.rb`

```ruby
Moneytree.setup do |config|
  config.enabled_psps = [:square, :stripe, :braintree]
  config.account_class = 'Account'
  config.order_class = 'Order'
  config.transaction_class = 'Transaction'

  config.square_credentials = {
    app_id: ENV['SQUARE_APP_ID'],
    app_secret: ENV['SQUARE_APP_SECRET'],
    environment: Rails.env.production? : 'production' : 'sandbox',
    oauth_domain: Rails.env.production? ? 'https://connect.squareup.com' : 'https://connect.squareupsandbox.com'
  }
end
```

## Usage

### The Primitives

Before you start using the Gem, it is good to understand the models and what they do. This Gem is made for people that
need payments for transactional orders. Think, an account holder that sells products. When an order is made there is a
transaction attached for the payment. You can name these models however you want yourself.

### The API

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kieranklaassen/moneytree. This project is
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[code of conduct](https://github.com/kieranklaassen/moneytree/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Moneytree project's codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/kieranklaassen/moneytree/blob/master/CODE_OF_CONDUCT.md).

rails g model payment_gateway psp_credentials:text moneytree_psp:integer account:references{polymorphic}

owner t.string :name t.text :psp_credentials t.integer :moneytree_psp

rails g model orders t.string :description t.string :remote_identifier t.references :customer t.references :account

rails g model transactions t.decimal :amount t.decimal :app_fee_amount t.integer :status t.integer :type t.string
:remote_identifier t.string :currency_code t.string :psp_error t.integer :moneytree_psp t.references :account
t.references :order t.references :card

rails g model customers t.string :first_name t.string :last_name t.string :email t.string :remote_identifier t.integer
:moneytree_psp t.references :account

rails g model cards t.string :card_brand t.string :last_4 t.integer :expiration_month t.integer :expiration_year
t.string :cardholder_name t.string :fingerprint t.integer :moneytree_psp t.references :customer t.references :account
