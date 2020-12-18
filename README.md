# 🚧 WORK IN PROGRESS 🚧

# Moneytree 💵 🌴

[![Actions Status](https://github.com/kieranklaassen/moneytree/workflows/build/badge.svg)](https://github.com/kieranklaassen/moneytree/actions)
[![Gem Version](https://badge.fury.io/rb/moneytree-rails.svg)](https://badge.fury.io/rb/moneytree-rails)

🔥 A powerful, simple, and extendable payment engine for rails, centered around transactional payments. 💵 🌴

Moneytree is a rails engine to add multi-PSP, multi-merchant payments to your app by extending your own models. It brings the following
functionality with almost no work on your end:

- 💵💶💷💴 Multi-currency
- 🔑 OAuth and PSP onboarding for your PSP from right inside your app
- 👩‍💻 PSP account creation, (with commission)
- ⚙️ Webhooks
- 💳 ~~Javascript libraries~~ comming soon
- 🧲 Platform fees
- 🚀 Market Place transfers for sending one customer charge to multiple accounts.

Currently we support the following PSP's:

- Stripe Connect Standard (Stripe with connected accounts)
- Stripe Connect Express (Stripe Marketplace) with multi transfers
- ~~Square~~ comming later

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
    client_id: ENV['STRIPE_CLIENT_ID'], # optional, only necessary for onboarding standard accounts in non-marketplace mode
    public_key: ENV['STRIPE_API_KEY'] # optional, only necessary for marketplace mode
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

  def name
    'My awesome business'
  end

  def website
    'https://www.boomtown.com'
  end

  # Optional, will be called by Moneytree after authenticating with the PSP
  def moneytree_oauth_callback
    puts "Hurray, I just got associated with a Moneytree gateway!"
  end

  # optional: when using market places onboarding via moneytree.onboarding_new_stripe_path
  def moneytree_onboarding_data
    {
      business_type: 'company',
      country: 'US',
      email: 'user@example.com',
      company: {
        name: 'User Example LLC',
        address: {
          line1: '1 N State St',
          line2: '',
          postal_code: '60602',
          city: 'Chicago',
          state: 'IL',
          country: 'US'
        },
        phone: '+17735551234',
        structure: 'multi_member_llc',
        tax_id: '980000000'
      }
    }
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

### Stripe

Where do I get my credentials from and what do I have to setup on my Stripe account? First, you need to have Stripe Connect enabled.

## Credentials

- Get api_key at https://dashboard.stripe.com/test/apikeys
- Get client id at: https://dashboard.stripe.com/settings/applications

### Oauth callback (For non-marketplace mode)

If you are tranferring the whole amount of the order to the account, you do not need market place mode and g=can integrate with Oauth. This is called Stripe connect Standard and will allow users to connect or sign up with their own Stripe account.

At https://dashboard.stripe.com/test/settings/applications:

- Enable OAuth for Standard accounts
- Add URI: `http://localhost:3000/moneytree/oauth/stripe/callback`

### Onboarding in Marketplace Mode (For multi-transfer orders)

In Marketplace mode, Moneytree will onboard merchants on Stripe Express accounts instead of Standard accounts. Your platform will play a more facilitory role in the onboarding process, but Moneytree will take care of the majority of it. This will give you the flexibility to split an order into multiple transfers to different accounts

To onboard a user to have your user navigate to `moneytree.onboarding_new_stripe_path`.

### Webhooks

At https://dashboard.stripe.com/webhooks

In the section titled "Endpoints receiving events from your account", create a webhook to `https://www.myawesomeappy.com/moneytree/webhooks/stripe` on your app's domain, adding the following events:

- `charge.succeeded`
- `charge.refunded`

Find the webhook secret, and save it in your credentials file at the stripe credentials, as `account_webhook_secret`

When using Moneytree in marketplace mode, there is another webhook you need to create. In the section titled "Endpoints receiving events from Connect applications", create a webhook to
`https://www.myawesomeappy.com/moneytree/webhooks/stripe` on your app's domain.

- Add `account.updated` if you are using Moneytree in Marketplace Mode.

Find the webhook secret, and save it in your credentials file at the stripe credentials, as `connect_webhook_secret`

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
