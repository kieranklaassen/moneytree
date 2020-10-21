Rails.application.routes.draw do
  resources :orders
  mount Moneytree::Engine => '/moneytree'
end
