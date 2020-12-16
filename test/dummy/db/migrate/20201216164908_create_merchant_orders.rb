class CreateMerchantOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :merchant_orders do |t|
      t.references :order, null: false, foreign_key: true
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
