# == Schema Information
#
# Table name: recovery_codes
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  used       :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_recovery_codes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe RecoveryCode, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end
end
