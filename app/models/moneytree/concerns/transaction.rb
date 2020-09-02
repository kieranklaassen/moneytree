module Moneytree
  module Transaction
    extend ActiveSupport::Concern

    included do
      enum type: %i[payment refund]
    end
  end
end
