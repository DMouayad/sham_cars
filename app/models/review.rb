# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  rating     :integer          not null
#  status     :integer          default(0), not null
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#  vehicle_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_status                  (status)
#  index_reviews_on_user_id                 (user_id)
#  index_reviews_on_user_id_and_vehicle_id  (user_id,vehicle_id) UNIQUE
#  index_reviews_on_vehicle_id              (vehicle_id)
#  index_reviews_on_vehicle_id_and_status   (vehicle_id,status)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (vehicle_id => vehicles.id)
#

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle, counter_cache: true

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :body, presence: true, length: { minimum: 10, maximum: 2000 }
  validates :title, length: { maximum: 100 }
  validates :user_id, uniqueness: { scope: :vehicle_id, message: "has already reviewed this vehicle" }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_rating, -> { order(rating: :desc) }

  after_save :update_vehicle_rating, if: :saved_change_to_status?
  after_destroy :update_vehicle_rating

  def rating_stars
    "★" * rating + "☆" * (5 - rating)
  end

  def approve!
    update!(status: :approved)
  end

  def reject!
    update!(status: :rejected)
  end

  private

  def update_vehicle_rating
    vehicle.update_rating_cache!
  end
end

