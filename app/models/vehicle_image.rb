# == Schema Information
#
# Table name: vehicle_images
#
#  id         :bigint           not null, primary key
#  alt_text   :string
#  position   :integer          default(0)
#  primary    :boolean          default(FALSE)
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  vehicle_id :bigint           not null
#
# Indexes
#
#  index_vehicle_images_on_vehicle_id               (vehicle_id)
#  index_vehicle_images_on_vehicle_id_and_position  (vehicle_id,position)
#
# Foreign Keys
#
#  fk_rails_...  (vehicle_id => vehicles.id)
#
class VehicleImage < ApplicationRecord
  # Associations
  belongs_to :vehicle

  # Validations
  validates :url, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Scopes
  scope :ordered, -> { order(primary: :desc, position: :asc) }

  # Callbacks
  before_save :ensure_single_primary, if: -> { primary? && primary_changed? }
  after_create :set_as_primary_if_first

  private

  def ensure_single_primary
    vehicle.images.where.not(id: id).update_all(primary: false)
  end

  def set_as_primary_if_first
    update_column(:primary, true) if vehicle.images.count == 1
  end
end

