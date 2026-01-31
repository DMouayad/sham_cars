# == Schema Information
#
# Table name: brands
#
#  id          :bigint           not null, primary key
#  country     :string
#  description :text
#  logo        :string
#  name        :string           not null
#  slug        :string           not null
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_brands_on_name  (name)
#  index_brands_on_slug  (slug) UNIQUE
#
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
  def self.ransackable_attributes(_auth_object = nil)
     %w[name slug country created_at]
   end

   def self.ransackable_associations(_auth_object = nil)
     %w[vehicles]
   end
end
