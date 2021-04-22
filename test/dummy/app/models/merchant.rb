class Merchant < ApplicationRecord
  include Moneytree::Account

  def email
    "test@example.com"
  end

  def currency_code
    "USD"
  end

  def website
    "https://www.example.com"
  end

  def moneytree_onboarding_data
    {
      business_type: "company",
      country: "US",
      email: "user@example.com",
      company: {
        name: "User Example LLC",
        address: {
          line1: "1 N State St",
          line2: "",
          postal_code: "60602",
          city: "Chicago",
          state: "IL",
          country: "US"
        },
        phone: "+17735551234",
        structure: "multi_member_llc",
        tax_id: "980000000"
      }
    }
  end
end
