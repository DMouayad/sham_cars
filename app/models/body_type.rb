# == Schema Information
#
# Table name: body_types
#
#  id          :bigint           not null, primary key
#  description :text
#  icon        :string
#  name        :string           not null
#  slug        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_body_types_on_slug  (slug) UNIQUE
#
class BodyType < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Associations
  has_many :vehicles, dependent: :nullify

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: true

  # Scopes
  scope :ordered, -> { order(:name) }

  # Icon mapping
  ICONS = {
    "sedan" => "🚗",
    "suv" => "🚙",
    "hatchback" => "🚘",
    "truck" => "🛻",
    "van" => "🚐",
    "coupe" => "🏎️",
    "wagon" => "🚃",
    "convertible" => "🏁",
    "crossover" => "🚙",
    "mpv" => "🚐"
  }.freeze

  # Methods
  def display_icon
    icon.presence || ICONS[slug] || "🚗"
  end

  def to_s
    name
  end
end
