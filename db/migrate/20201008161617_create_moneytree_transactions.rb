class CreateMoneytreeTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :moneytree_transactions do |t|
      t.decimal :amount, null: false, default: 0
      t.decimal :app_fee_amount
      t.integer :status, null: false, default: 0
      t.string :type, null: false, default: "Moneytree::Payment"
      t.references :order, polymorphic: true, null: false
      t.references :payment_gateway
      t.references :payment, foreign_key: {to_table: :moneytree_transactions}
      t.text :psp_error
      t.text :details
      t.text :refund_reason

      t.timestamps
    end
  end
end
