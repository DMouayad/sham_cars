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
