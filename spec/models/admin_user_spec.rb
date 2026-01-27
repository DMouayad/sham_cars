# == Schema Information
#
# Table name: admin_users
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#  role            :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_admin_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
