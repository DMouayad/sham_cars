module EventTracking
  extend ActiveSupport::Concern

  private

  def track_event(action:, eventable: nil)
    return unless current_user

    Event.create!(
      user: current_user,
      action: action,
      eventable: eventable
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.warn("Event not saved: #{e.message}")
  end
end
