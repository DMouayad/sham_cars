# == Schema Information
#
# Table name: sign_in_tokens
#
#  id      :bigint           not null, primary key
#  user_id :integer          not null
#
# Indexes
#
#  index_sign_in_tokens_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class SignInToken < ApplicationRecord
  belongs_to :user
end
