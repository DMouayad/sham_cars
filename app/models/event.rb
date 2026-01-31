# == Schema Information
#
# Table name: events
#
#  id             :bigint           not null, primary key
#  action         :string           not null
#  eventable_type :string
#  ip_address     :string
#  user_agent     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  eventable_id   :bigint
#  user_id        :bigint           not null
#
# Indexes
#
#  index_events_on_action_and_created_at              (action,created_at)
#  index_events_on_eventable                          (eventable_type,eventable_id)
#  index_events_on_user_id                            (user_id)
#  index_events_on_user_id_and_action_and_created_at  (user_id,action,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Event < ApplicationRecord
  belongs_to :user
  belongs_to :eventable, polymorphic: true, optional: true

  before_create do
    self.user_agent = Current.user_agent
    self.ip_address = Current.ip_address
  end

  validates :action, presence: true
end
