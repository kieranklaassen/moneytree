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

ActiveRecord::Schema.define(version: 2020_10_08_162843) do

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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_type", "account_id"], name: "index_moneytree_pg_account_type_and_account_id"
  end

  create_table "moneytree_transactions", force: :cascade do |t|
    t.decimal "amount", default: "0.0", null: false
    t.decimal "app_fee_amount", default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.integer "kind", default: 0, null: false
    t.string "order_type", null: false
    t.integer "order_id", null: false
    t.integer "payment_gateway_id", null: false
    t.text "psp_error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_type", "order_id"], name: "index_moneytree_transactions_on_order_type_and_order_id"
    t.index ["payment_gateway_id"], name: "index_moneytree_transactions_on_payment_gateway_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "merchant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  add_foreign_key "orders", "merchants"
end
