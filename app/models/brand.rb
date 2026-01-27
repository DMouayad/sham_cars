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
end
