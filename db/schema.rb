# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_23_163742) do
  create_table "addresses", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "street", null: false
    t.string "number"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zipcode", null: false
    t.string "supplement"
    t.string "district", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_addresses_on_customer_id"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "token", null: false
    t.string "last_digits", null: false
    t.string "brand", null: false
    t.string "expiration_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_credit_cards_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.integer "due_day", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method", null: false
    t.string "email", null: false
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.check_constraint "due_day >= 1 AND due_day <= 31", name: "due_day_range"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "payment_method", null: false
    t.date "due_date", null: false
    t.integer "status", default: 0, null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "customers"
  add_foreign_key "credit_cards", "customers"
  add_foreign_key "invoices", "customers"
end
