Moneytree::Engine.routes.draw do
  get 'oauth/stripe/new', to: 'oauth/stripe#new'
  get 'oauth/stripe/callback', to: 'oauth/stripe#callback'
end
