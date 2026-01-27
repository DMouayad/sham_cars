# == Schema Information
#
# Table name: vehicles
#
#  id                   :bigint           not null, primary key
#  acceleration_0_100   :decimal(4, 1)
#  average_rating       :decimal(3, 2)    default(0.0)
#  battery_capacity_kwh :decimal(6, 1)
#  cargo_volume_liters  :integer
#  charge_port          :string
#  currency             :string           default("USD")
#  description          :text
#  drive_type           :string
#  efficiency_wh_km     :integer
#  fast_charge_kw       :integer
#  fast_charge_time_min :integer
#  featured             :boolean          default(FALSE)
#  height_mm            :integer
#  home_charge_kw       :decimal(4, 1)
#  horsepower           :integer
#  length_mm            :integer
#  name                 :string           not null
#  price_from           :decimal(12, 2)
#  price_to             :decimal(12, 2)
#  published            :boolean          default(FALSE)
#  range_epa_miles      :integer
#  range_wltp_km        :integer
#  reviews_count        :integer          default(0)
#  seats                :integer
#  slug                 :string           not null
#  status               :integer          default(0), not null
#  top_speed_kmh        :integer
#  torque_nm            :integer
#  weight_kg            :integer
#  wheelbase_mm         :integer
#  width_mm             :integer
#  year                 :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  body_type_id         :bigint           not null
#  brand_id             :bigint           not null
#
# Indexes
#
#  index_vehicles_on_body_type_id   (body_type_id)
#  index_vehicles_on_brand_id       (brand_id)
#  index_vehicles_on_featured       (featured)
#  index_vehicles_on_price_from     (price_from)
#  index_vehicles_on_published      (published)
#  index_vehicles_on_range_wltp_km  (range_wltp_km)
#  index_vehicles_on_slug           (slug) UNIQUE
#  index_vehicles_on_status         (status)
#  index_vehicles_on_year           (year)
#
# Foreign Keys
#
#  fk_rails_...  (body_type_id => body_types.id)
#  fk_rails_...  (brand_id => brands.id)
#
FactoryBot.define do
  factory :vehicle do
    brand { nil }
    body_type { nil }
    name { "MyString" }
    slug { "MyString" }
    description { "MyText" }
    year { 1 }
    status { 1 }
    price_from { "9.99" }
    price_to { "9.99" }
    currency { "MyString" }
    battery_capacity_kwh { "9.99" }
    range_wltp_km { 1 }
    range_epa_miles { 1 }
    acceleration_0_100 { "9.99" }
    top_speed_kmh { 1 }
    horsepower { 1 }
    torque_nm { 1 }
    drive_type { "MyString" }
    fast_charge_kw { 1 }
    fast_charge_time_min { 1 }
    home_charge_kw { "9.99" }
    charge_port { "MyString" }
    length_mm { 1 }
    width_mm { 1 }
    height_mm { 1 }
    wheelbase_mm { 1 }
    weight_kg { 1 }
    cargo_volume_liters { 1 }
    frunk_volume_liters { 1 }
    seats { 1 }
    featured { false }
    published { false }
  end
end
