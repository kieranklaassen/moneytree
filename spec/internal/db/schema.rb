# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table(:accounts, force: true) do |t|
    t.string :name
    t.integer :psp
    t.timestamps
  end

  create_table(:orders, force: true) do |t|
    t.string :description
    t.string :remote_identifier
    t.references :customer
    t.references :account
    t.timestamps
  end

  create_table(:transactions, force: true) do |t|
    t.decimal :amount
    t.decimal :app_fee_amount
    t.integer :status
    t.string :remote_identifier
    t.string :currency_code
    t.integer :psp
    t.references :account
    t.references :order
    t.references :card
    t.timestamps
  end

  create_table(:customers, force: true) do |t|
    t.string :first_name
    t.string :last_name
    t.string :email
    t.string :remote_identifier
    t.integer :psp
    t.references :account
    t.timestamps
  end

  create_table(:cards, force: true) do |t|
    t.string :card_brand
    t.string :last_4
    t.integer :expiration_month
    t.integer :expiration_year
    t.string :cardholder_name
    t.string :fingerprint
    t.integer :psp
    t.references :customer
    t.references :account
    t.timestamps
  end
end
