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
require 'rails_helper'

RSpec.describe BodyType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
