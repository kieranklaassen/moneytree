Moneytree::Engine.routes.draw do
  get 'mt/oauth/stripe/new', to: 'oauth/stripe#new'
  get 'mt/oauth/stripe/callback', to: 'oauth/stripe#callback'
end
