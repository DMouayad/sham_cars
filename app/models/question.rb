# == Schema Information
#
# Table name: questions
#
#  id            :bigint           not null, primary key
#  answers_count :integer          default(0), not null
#  body          :text             not null
#  status        :integer          default("published"), not null
#  title         :string           not null
#  views_count   :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_questions_on_created_at  (created_at)
#  index_questions_on_status      (status)
#  index_questions_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  enum :status, { hidden: 0, published: 1 }

  validates :title, presence: true
  validates :body, presence: true
end
