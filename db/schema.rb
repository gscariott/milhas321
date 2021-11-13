# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_13_181242) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "airlines", force: :cascade do |t|
    t.string "name"
    t.integer "cnpj"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_airlines_on_user_id"
  end

  create_table "miles_offers", force: :cascade do |t|
    t.integer "quantity"
    t.boolean "available", default: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_miles_offers_on_user_id"
  end

  create_table "sites", force: :cascade do |t|
    t.decimal "mile_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "airline_id"
    t.string "flight"
    t.string "batch"
    t.datetime "max_cancellation_date"
    t.datetime "departure"
    t.string "from"
    t.string "to"
    t.decimal "value"
    t.string "airplane"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["airline_id"], name: "index_tickets_on_airline_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.integer "miles", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", limit: 191
    t.integer "cpf_cnpj"
    t.integer "user_type", limit: 2
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "airlines", "users"
  add_foreign_key "miles_offers", "users"
  add_foreign_key "tickets", "airlines"
end
