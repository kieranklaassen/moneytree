class ApplicationController < ActionController::Base
  # Stub for logged in merchant
  def current_merchant
    Merchant.find_or_create_by(name: 'Test Merchant')
  end
end
