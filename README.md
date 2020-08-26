# 🚧 WORK IN PROGRESS 🚧

# Moneytreen 💵 🌴

[![Actions Status](https://github.com/kieranklaassen/moneytree/workflows/build/badge.svg)](https://github.com/kieranklaassen/moneytree/actions)
[![Gem Version](https://badge.fury.io/rb/moneytree.svg)](https://badge.fury.io/rb/moneytree)

🔥 Moneytree is a rails engine to add multi-psp payments to your app without needing to think about Ouath, callbacks, PCI
compliance, platform fees, multi-currency, and more. We give you a lot of ways to extend your own classes so that you
can focus on your business logic instead of integration with payment service providers.

Currently we support the following PSP's:

- Square
- Stripe
- Braintree

But if you want to add more, we make it easy to do so. Read our
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
$ bundle add moneytree
$ bundle install
```

Add

### Credentials

You'll need to add your Psp credentials to secrets `config/secrets.yml`, credentials `rails credentials:edit`

```yaml
development:
  stripe:
    private_key: xxxx
    public_key: yyyy
    signing_secret: zzzz
  braintree:
    private_key: xxxx
    public_key: yyyy
    merchant_id: aaaa
    environment: sandbox
  square:
    access_token: token
    environment: sandbox
```

Or your can use environment variables:

For Stripe, you can also use the `STRIPE_PUBLIC_KEY`, `STRIPE_PRIVATE_KEY` and `STRIPE_SIGNING_SECRET` environment
variables. For Braintree, you can also use `BRAINTREE_MERCHANT_ID`, `BRAINTREE_PUBLIC_KEY`, `BRAINTREE_PRIVATE_KEY`, and
`BRAINTREE_ENVIRONMENT` environment variables. For Square, you can also use the `SQUARE_ACCESS_TOKEN`, and
`SQUARE_ENVIRONMENT`

## Configuration

Do you need to make some changes to how Moneytree is used? You can create an initializer
`config/initializers/moneytree.rb`

```ruby
Moneytree.setup do |config|
  config.enabled_psps = [:square, :stripe, :braintree]

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
