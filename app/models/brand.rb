class Brand < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Associations
  has_many :vehicles, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: true

  # Scopes
  scope :ordered, -> { order(:name) }
  scope :with_published_vehicles, -> {
    joins(:vehicles).where(vehicles: { published: true }).distinct
  }

  # Methods
  def published_vehicles_count
    vehicles.where(published: true).count
  end

  def to_s
    name
  end
end
