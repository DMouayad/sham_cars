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
class AdminUser < ApplicationRecord
end
