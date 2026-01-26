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

ActiveRecord::Schema[8.1].define(version: 2026_01_26_091517) do
  create_table "body_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_body_types_on_slug", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.string "country"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "logo"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["name"], name: "index_brands_on_name"
    t.index ["slug"], name: "index_brands_on_slug", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "vehicle_images", force: :cascade do |t|
    t.string "alt_text"
    t.datetime "created_at", null: false
    t.integer "position", default: 0
    t.boolean "primary", default: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.integer "vehicle_id", null: false
    t.index ["vehicle_id", "position"], name: "index_vehicle_images_on_vehicle_id_and_position"
    t.index ["vehicle_id"], name: "index_vehicle_images_on_vehicle_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.decimal "acceleration_0_100", precision: 4, scale: 1
    t.decimal "battery_capacity_kwh", precision: 6, scale: 1
    t.integer "body_type_id", null: false
    t.integer "brand_id", null: false
    t.integer "cargo_volume_liters"
    t.string "charge_port"
    t.datetime "created_at", null: false
    t.string "currency", default: "USD"
    t.text "description"
    t.string "drive_type"
    t.integer "efficiency_wh_km"
    t.integer "fast_charge_kw"
    t.integer "fast_charge_time_min"
    t.boolean "featured", default: false
    t.integer "height_mm"
    t.decimal "home_charge_kw", precision: 4, scale: 1
    t.integer "horsepower"
    t.integer "length_mm"
    t.string "name", null: false
    t.decimal "price_from", precision: 12, scale: 2
    t.decimal "price_to", precision: 12, scale: 2
    t.boolean "published", default: false
    t.integer "range_epa_miles"
    t.integer "range_wltp_km"
    t.integer "seats"
    t.string "slug", null: false
    t.integer "status", default: 0, null: false
    t.integer "top_speed_kmh"
    t.integer "torque_nm"
    t.datetime "updated_at", null: false
    t.integer "weight_kg"
    t.integer "wheelbase_mm"
    t.integer "width_mm"
    t.integer "year"
    t.index ["body_type_id"], name: "index_vehicles_on_body_type_id"
    t.index ["brand_id"], name: "index_vehicles_on_brand_id"
    t.index ["featured"], name: "index_vehicles_on_featured"
    t.index ["price_from"], name: "index_vehicles_on_price_from"
    t.index ["published"], name: "index_vehicles_on_published"
    t.index ["range_wltp_km"], name: "index_vehicles_on_range_wltp_km"
    t.index ["slug"], name: "index_vehicles_on_slug", unique: true
    t.index ["status"], name: "index_vehicles_on_status"
    t.index ["year"], name: "index_vehicles_on_year"
  end

  add_foreign_key "sessions", "users"
  add_foreign_key "vehicle_images", "vehicles"
  add_foreign_key "vehicles", "body_types"
  add_foreign_key "vehicles", "brands"
end
