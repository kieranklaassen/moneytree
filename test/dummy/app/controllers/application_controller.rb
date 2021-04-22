class ApplicationController < ActionController::Base
  def current_merchant
    Merchant.find_or_create_by(name: "Test Merchant")
  end
end
