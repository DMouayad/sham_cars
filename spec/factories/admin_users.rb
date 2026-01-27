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
FactoryBot.define do
  factory :admin_user do
    email { "MyString" }
    password_digest { "MyString" }
    name { "MyString" }
    role { 1 }
  end
end
