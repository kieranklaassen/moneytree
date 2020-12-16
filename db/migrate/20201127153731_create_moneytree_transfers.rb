class CreateMoneytreeTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :moneytree_transfers do |t|
      t.references :account_order, polymorphic: true, null: false, index: { name: 'index_moneytree_transfers_on_account_order_id_and_type' }
      t.references :payment_gateway, null: false, foreign_key: { to_table: :moneytree_payment_gateways }
      t.references :payout, foreign_key: { to_table: :moneytree_transfers }
      t.references :transaction, foreign_key: { to_table: :moneytree_transactions }
      t.string :type, null: false, default: 'Moneytree::Payout'
      t.decimal :amount
      t.text :details
      t.text :psp_error
      t.text :refund_reason

      t.timestamps
    end
  end
end
