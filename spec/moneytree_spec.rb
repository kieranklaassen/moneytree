RSpec.describe Moneytree do # rubocop:disable Metrics/BlockLength
  it 'has a version number' do
    expect(Moneytree::VERSION).not_to be nil
  end

  it 'has correct default settings' do
    expect(subject).to have_attributes(
      enabled_psps: %i[square stripe braintree],
      account_class: 'Account',
      order_class: 'Order',
      transaction_class: 'Transaction'
    )
  end

  describe 'with custom settings' do
    before do
      Moneytree.setup do |config|
        config.enabled_psps = %i[square]
      end
    end

    it { is_expected.to have_attributes(enabled_psps: %i[square]) }
  end

  describe Moneytree::Account do
    let(:square_credentials) { { access_token: 'token', environment: 'sandbox' } }
    subject { Account.create(name: 'Boomtown BV', psp_credentials: square_credentials, moneytree_psp: :square) }

    it { is_expected.to have_attributes(moneytree_psp: 'square', oauth_link: 'https://connect.squareupsandbox.com/oauth2/authorize?client_id=app_id&scope=MERCHANT_PROFILE_READ+PAYMENTS_WRITE+PAYMENTS_READ+CUSTOMERS_WRITE+PAYMENTS_WRITE_ADDITIONAL_RECIPIENTS') }
    it { is_expected.to respond_to(:client) }
    it { is_expected.to respond_to(:oauth_link) }
  end

  describe Moneytree::Transaction do
    subject { Transaction.new }
  end
end
