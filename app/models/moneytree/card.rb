module Moneytree
  class Card
    include ActiveModel::Model

    attr_accessor(
      :last4,
      :exp_month,
      :exp_year,
      :fingerprint,
      :brand,
      :address_zip,
      :country
    )
  end
end
