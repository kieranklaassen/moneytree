# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_16_164908) do

  create_table "merchant_orders", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "merchant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["merchant_id"], name: "index_merchant_orders_on_merchant_id"
    t.index ["order_id"], name: "index_merchant_orders_on_order_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "moneytree_payment_gateways", force: :cascade do |t|
    t.text "psp_credentials"
    t.integer "psp", null: false
    t.string "account_type"
    t.integer "account_id"
    t.boolean "onboarding_completed", default: false, null: false
    t.boolean "marketplace_capable", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_type", "account_id"], name: "index_moneytree_pg_account_type_and_account_id"
  end

  create_table "moneytree_transactions", force: :cascade do |t|
    t.decimal "amount", default: "0.0", null: false
    t.decimal "app_fee_amount", default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.string "type", default: "Moneytree::Payment", null: false
    t.string "order_type", null: false
    t.integer "order_id", null: false
    t.integer "payment_gateway_id", null: false
    t.integer "payment_id"
    t.text "psp_error"
    t.text "details"
    t.text "refund_reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_type", "order_id"], name: "index_moneytree_transactions_on_order_type_and_order_id"
    t.index ["payment_gateway_id"], name: "index_moneytree_transactions_on_payment_gateway_id"
    t.index ["payment_id"], name: "index_moneytree_transactions_on_payment_id"
  end

  create_table "moneytree_transfers", force: :cascade do |t|
    t.string "account_order_type", null: false
    t.integer "account_order_id", null: false
    t.integer "payment_gateway_id", null: false
    t.integer "payout_id"
    t.integer "transaction_id"
    t.string "type", default: "Moneytree::Payout", null: false
    t.decimal "amount"
    t.text "details"
    t.text "psp_error"
    t.text "refund_reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_order_type", "account_order_id"], name: "index_moneytree_transfers_on_account_order_id_and_type"
    t.index ["payment_gateway_id"], name: "index_moneytree_transfers_on_payment_gateway_id"
    t.index ["payout_id"], name: "index_moneytree_transfers_on_payout_id"
    t.index ["transaction_id"], name: "index_moneytree_transfers_on_transaction_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "merchant_orders", "merchants"
  add_foreign_key "merchant_orders", "orders"
  add_foreign_key "moneytree_transactions", "moneytree_transactions", column: "payment_id"
  add_foreign_key "moneytree_transfers", "moneytree_payment_gateways", column: "payment_gateway_id"
  add_foreign_key "moneytree_transfers", "moneytree_transactions", column: "transaction_id"
  add_foreign_key "moneytree_transfers", "moneytree_transfers", column: "payout_id"
end
