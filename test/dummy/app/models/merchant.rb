class Merchant < ApplicationRecord
  include Moneytree::Account

  def email
    'test@example.com'
  end

  def currency_code
    'USD'
  end

  def website
    'https://www.example.com'
  end
end
