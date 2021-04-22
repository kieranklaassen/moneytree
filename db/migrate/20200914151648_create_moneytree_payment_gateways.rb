class CreateMoneytreePaymentGateways < ActiveRecord::Migration[6.0]
  def change
    create_table :moneytree_payment_gateways do |t|
      t.text :psp_credentials
      t.integer :psp, null: false
      t.references :account, polymorphic: true, index: {name: "index_moneytree_pg_account_type_and_account_id"}
      t.boolean :onboarding_completed, null: false, default: false
      t.boolean :marketplace_capable, null: false, default: false

      t.timestamps
    end
  end
end
