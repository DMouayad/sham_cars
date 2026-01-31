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

ActiveRecord::Schema[8.1].define(version: 2026_01_30_161346) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.integer "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.bigint "question_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["created_at"], name: "index_answers_on_created_at"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

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

  create_table "events", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.bigint "eventable_id"
    t.string "eventable_type"
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["action", "created_at"], name: "index_events_on_action_and_created_at"
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable"
    t.index ["user_id", "action", "created_at"], name: "index_events_on_user_id_and_action_and_created_at"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "answers_count", default: 0, null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "status", default: 1, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "views_count", default: 0, null: false
    t.index ["created_at"], name: "index_questions_on_created_at"
    t.index ["status"], name: "index_questions_on_status"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "recovery_codes", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "used", default: false, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_recovery_codes_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "rating", null: false
    t.integer "status", default: 1, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "vehicle_id", null: false
    t.index ["status"], name: "index_reviews_on_status"
    t.index ["user_id", "vehicle_id"], name: "index_reviews_on_user_id_and_vehicle_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
    t.index ["vehicle_id", "status"], name: "index_reviews_on_vehicle_id_and_status"
    t.index ["vehicle_id"], name: "index_reviews_on_vehicle_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "sudo_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "sign_in_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sign_in_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.boolean "otp_required_for_sign_in", default: false, null: false
    t.string "otp_secret", null: false
    t.string "password_digest", null: false
    t.string "provider"
    t.integer "role", default: 0, null: false
    t.integer "theme", default: 0, null: false
    t.string "uid"
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "verified", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "vehicle_images", force: :cascade do |t|
    t.string "alt_text"
    t.datetime "created_at", null: false
    t.integer "position", default: 0
    t.boolean "primary", default: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.bigint "vehicle_id", null: false
    t.index ["vehicle_id", "position"], name: "index_vehicle_images_on_vehicle_id_and_position"
    t.index ["vehicle_id"], name: "index_vehicle_images_on_vehicle_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.decimal "acceleration_0_100", precision: 4, scale: 1
    t.decimal "average_rating", precision: 3, scale: 2, default: "0.0"
    t.decimal "battery_capacity_kwh", precision: 6, scale: 1
    t.bigint "body_type_id", null: false
    t.bigint "brand_id", null: false
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
    t.integer "reviews_count", default: 0
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "events", "users"
  add_foreign_key "questions", "users"
  add_foreign_key "recovery_codes", "users"
  add_foreign_key "reviews", "users"
  add_foreign_key "reviews", "vehicles"
  add_foreign_key "sessions", "users"
  add_foreign_key "sign_in_tokens", "users"
  add_foreign_key "vehicle_images", "vehicles"
  add_foreign_key "vehicles", "body_types"
  add_foreign_key "vehicles", "brands"
end
