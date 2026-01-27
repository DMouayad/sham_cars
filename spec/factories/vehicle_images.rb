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
FactoryBot.define do
  factory :vehicle_image do
    vehicle { nil }
    url { "MyString" }
    alt_text { "MyString" }
    position { 1 }
    primary { false }
  end
end
