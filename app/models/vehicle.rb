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
#  status               :integer          default("draft"), not null
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
class Vehicle < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # Associations
  belongs_to :brand
  belongs_to :body_type
  has_many :images, class_name: "VehicleImage", dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :approved_reviews, -> { approved }, class_name: "Review"

  # Enums
  enum :status, { draft: 0, published: 1, coming_soon: 2, discontinued: 3 }

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :year, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 2010,
    less_than_or_equal_to: -> { Time.current.year + 2 },
    allow_nil: true
  }
  validates :price_from, numericality: { greater_than: 0, allow_nil: true }
  validates :price_to, numericality: { greater_than: 0, allow_nil: true }
  validates :battery_capacity_kwh, numericality: { greater_than: 0, allow_nil: true }
  validates :range_wltp_km, numericality: { only_integer: true, greater_than: 0, allow_nil: true }
  validates :seats, numericality: { only_integer: true, in: 1..9, allow_nil: true }

  # Scopes
  scope :published_vehicles, -> { where(published: true) }
  scope :featured, -> { where(featured: true) }
  scope :ordered_by_newest, -> { order(year: :desc, created_at: :desc) }
  scope :ordered_by_price_asc, -> { order(price_from: :asc) }
  scope :ordered_by_price_desc, -> { order(price_from: :desc) }
  scope :ordered_by_range, -> { order(range_wltp_km: :desc) }
  scope :by_brand, ->(brand_id) { where(brand_id: brand_id) }
  scope :by_body_type, ->(body_type_id) { where(body_type_id: body_type_id) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    %w[
    name year price_from price_to range_wltp_km battery_capacity_kwh
    acceleration_0_100 top_speed_kmh horsepower seats drive_type
    brand_id body_type_id published featured created_at average_rating
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[brand body_type]
  end

  # Instance Methods
  def full_name
    "#{brand.name} #{name}"
  end

  def primary_image
    images.find_by(primary: true) || images.order(:position).first
  end

  def primary_image_url
    primary_image&.url || placeholder_image_url
  end

  def placeholder_image_url
    "https://placehold.co/800x500/1f2937/ffffff?text=#{CGI.escape(full_name)}"
  end

  def price_display
    return "TBA" unless price_from

    formatted_min = format_currency(price_from)
    return formatted_min unless price_to && price_to > price_from

    "#{formatted_min} - #{format_currency(price_to)}"
  end

  def currency_symbol
    case currency
    when "EUR" then "€"
    when "GBP" then "£"
    else "$"
    end
  end

  def range_display
    return nil unless range_wltp_km
    "#{range_wltp_km} km"
  end

  def acceleration_display
    return nil unless acceleration_0_100
    "#{acceleration_0_100}s"
  end

  def battery_display
    return nil unless battery_capacity_kwh
    "#{battery_capacity_kwh} kWh"
  end

  def fast_charge_display
    return nil unless fast_charge_kw
    "#{fast_charge_kw} kW"
  end

  def specs_summary
    [
      { icon: "🔋", label: "Range", value: range_display },
      { icon: "⚡", label: "Battery", value: battery_display },
      { icon: "🏃", label: "0-100", value: acceleration_display },
      { icon: "🔌", label: "Fast Charge", value: fast_charge_display }
    ].select { |spec| spec[:value].present? }
  end

  def to_s
    full_name
  end

  private

  def slug_candidates
    [
      [:name],
      [:brand, :name],
      [:brand, :name, :year]
    ]
  end
  # Rating methods
    def update_rating_cache!
      approved = reviews.approved
      if approved.any?
        update_columns(
          reviews_count: approved.count,
          average_rating: approved.average(:rating).to_f.round(2)
        )
      else
        update_columns(reviews_count: 0, average_rating: 0.0)
      end
    end

    def rating_display
      return nil if reviews_count.zero?
      "#{average_rating.round(1)} (#{reviews_count})"
    end

    def rating_stars
      return "No reviews" if reviews_count.zero?
      full_stars = average_rating.floor
      "★" * full_stars + "☆" * (5 - full_stars)
    end
  def format_currency(amount)
    ActiveSupport::NumberHelper.number_to_currency(
      amount,
      precision: 0,
      unit: currency_symbol
    )
  end
end
