class CreateMoneytreePaymentGateways < ActiveRecord::Migration[6.0]
  def change
    create_table :moneytree_payment_gateways do |t|
      t.text :psp_credentials
      t.integer :moneytree_psp, null: false
      t.references :account, polymorphic: true, null: false, index: { name: 'index_moneytree_pg_account_type_and_account_id' }

      t.timestamps
    end
  end
end
