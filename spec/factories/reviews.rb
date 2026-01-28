# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  rating     :integer          not null
#  status     :integer          default("approved"), not null
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
FactoryBot.define do
  factory :review do
    vehicle { nil }
    author_name { "MyString" }
    author_email { "MyString" }
    rating { 1 }
    title { "MyString" }
    body { "MyText" }
    pros { "MyText" }
    cons { "MyText" }
    status { 1 }
    submitted_at { "2026-01-27 16:38:30" }
    approved_at { "2026-01-27 16:38:30" }
    ip_address { "MyString" }
  end
end
