class Vehicle < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # Associations
  belongs_to :brand
  belongs_to :body_type
  has_many :images, class_name: "VehicleImage", dependent: :destroy

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
      brand_id body_type_id published featured created_at
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

  def format_currency(amount)
    ActiveSupport::NumberHelper.number_to_currency(
      amount,
      precision: 0,
      unit: currency_symbol
    )
  end
end
