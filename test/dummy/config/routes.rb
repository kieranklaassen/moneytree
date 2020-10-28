Rails.application.routes.draw do
  resources :refunds
  resources :orders
  mount Moneytree::Engine => '/moneytree'
end
