# 🚧 WORK IN PROGRESS 🚧

# Moneytree 💵 🌴

[![Actions Status](https://github.com/kieranklaassen/moneytree/workflows/build/badge.svg)](https://github.com/kieranklaassen/moneytree/actions)
[![Gem Version](https://badge.fury.io/rb/moneytree-rails.svg)](https://badge.fury.io/rb/moneytree-rails)

🔥 A powerful, simple, and extendable payment engine for rails, centered around transactional payments. 💵 🌴

Moneytree is a rails engine to add multi-PSP payments to your app by extending your own models. It brings the following
functionality with almost no work on your end:

- 💵💶💷💴 Multi-currency
- 🔑 OAuth to link your PSP account
- 👩‍💻 PSP account creation, (with commission)
- ⚙️ ~~Webhooks~~ comming soon
- 💳 ~~PCI compliance with Javascript libraries~~ comming soon
- 🧲 Platform fees a.k.a. Market Places

Currently we support the following PSP's:

- ~~Square~~ comming soon
- Stripe
- ~~Braintree~~ comming soon

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
$ rails g moneytree:install:migrations
$ rails g db:migrate
```

## Configuration

### Initializer

Do you need to make some changes to how Moneytree is used? You can create an initializer
`config/initializers/moneytree.rb`

```ruby
Moneytree.setup do |config|
  config.current_account = :current_merchant
  config.stripe_credentials = {
    api_key: ENV['STRIPE_API_KEY'],
    client_id: ENV['STRIPE_CLIENT_ID']
  }
  config.oauth_redirect = '/welcome_back'
  config.refund_application_fee = true # false by default
end
```

### Routes

Add to your routes and authenticate if needed to make sure only admins can integrate with OAuth.

```ruby
  authenticate :user, ->(u) { u.admin? } do
    mount Moneytree::Engine => '/moneytree'
  end
```

### Models

Include account concern into your models and make sure the following attributes work:

```ruby
class Merchant < ApplicationRecord
  include Moneytree::Account

  def email
    owner.email
  end

  def currency_code
    currency.code
  end

  def website
    'https://www.boomtown.com'
  end
end
```

And add `Moneytree::Order` concern to the model that will be the parent for all the transactions. In most cases this
will be an order. This model will keep a balance and you can add multiple payments and refunds to it.

```ruby
class Order < ApplicationRecord
  include Moneytree::Order
end
```

## Usage

### The Primitives

Before you start using the Gem, it is good to understand the models and what they do. This Gem is made for people that
need payments for transactional orders. Think, an account holder that sells products. When an order is made there is a
transaction attached for the payment. You can name these models however you want yourself.

### The API

#### Moneytree::PaymentGateway

##### #method here

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

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Moneytree project's codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/kieranklaassen/moneytree/blob/master/CODE_OF_CONDUCT.md).
