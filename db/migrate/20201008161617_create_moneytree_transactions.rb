class CreateMoneytreeTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :moneytree_transactions do |t|
      t.decimal :amount, null: false, default: 0
      t.decimal :app_fee_amount, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.integer :kind, null: false, default: 0
      t.references :order, polymorphic: true, null: false
      t.references :payment_gateway, null: false

      t.timestamps
    end
  end
end
