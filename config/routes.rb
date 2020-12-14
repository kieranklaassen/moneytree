Moneytree::Engine.routes.draw do
  get 'oauth/stripe/new', to: 'oauth/stripe#new'
  get 'oauth/stripe/callback', to: 'oauth/stripe#callback'

  get 'onboarding/stripe/new', to: 'onboarding/stripe#new'
  get 'onboarding/stripe/onboard', to: 'onboarding/stripe#onboard'

  namespace :webhooks do
    resources :stripe, only: :create
  end
end
