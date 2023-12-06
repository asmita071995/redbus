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

ActiveRecord::Schema[7.0].define(version: 2023_11_24_093158) do
  create_table "bookings", force: :cascade do |t|
    t.integer "seat_booked"
    t.integer "bus_route_id", null: false
    t.integer "user_id", null: false
    t.integer "seat_number"
    t.string "status"
    t.string "ticket_no"
    t.integer "bus_id"
    t.integer "pickup_point_id"
    t.integer "drop_point_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bus_route_id"], name: "index_bookings_on_bus_route_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "bus_routes", force: :cascade do |t|
    t.integer "available_seats"
    t.date "date"
    t.integer "from_id"
    t.integer "to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buses", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.integer "total_seats"
    t.integer "available_seats"
    t.integer "bus_route_id", null: false
    t.integer "fare"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "departure_time"
    t.datetime "arrival_time"
    t.index ["bus_route_id"], name: "index_buses_on_bus_route_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "point"
    t.integer "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "amount"
    t.text "description"
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "type"
    t.string "role"
    t.string "mobile_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.string "total_balance"
    t.string "available_balance"
    t.integer "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bookings", "bus_routes"
  add_foreign_key "bookings", "users"
  add_foreign_key "buses", "bus_routes"
end
