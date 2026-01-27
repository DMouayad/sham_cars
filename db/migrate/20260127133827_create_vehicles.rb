
class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      # Associations
      t.references :brand, null: false, foreign_key: true
      t.references :body_type, null: false, foreign_key: true

      # Basic Info
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.integer :year
      t.integer :status, default: 0, null: false

      # Pricing
      t.decimal :price_from, precision: 12, scale: 2
      t.decimal :price_to, precision: 12, scale: 2
      t.string :currency, default: "USD"

      # Battery & Range
      t.decimal :battery_capacity_kwh, precision: 6, scale: 1
      t.integer :range_wltp_km
      t.integer :range_epa_miles
      t.integer :efficiency_wh_km

      # Performance
      t.decimal :acceleration_0_100, precision: 4, scale: 1
      t.integer :top_speed_kmh
      t.integer :horsepower
      t.integer :torque_nm
      t.string :drive_type

      # Charging
      t.integer :fast_charge_kw
      t.integer :fast_charge_time_min
      t.decimal :home_charge_kw, precision: 4, scale: 1
      t.string :charge_port

      # Dimensions
      t.integer :length_mm
      t.integer :width_mm
      t.integer :height_mm
      t.integer :wheelbase_mm
      t.integer :weight_kg
      t.integer :cargo_volume_liters
      t.integer :seats

      # Flags
      t.boolean :featured, default: false
      t.boolean :published, default: false

      # Cached counters
      t.integer :reviews_count, default: 0
      t.decimal :average_rating, precision: 3, scale: 2, default: 0.0

      t.timestamps
    end

    add_index :vehicles, :slug, unique: true
    add_index :vehicles, :status
    add_index :vehicles, :published
    add_index :vehicles, :featured
    add_index :vehicles, :year
    add_index :vehicles, :price_from
    add_index :vehicles, :range_wltp_km
  end
end
