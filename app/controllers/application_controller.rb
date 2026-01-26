
class ApplicationController < ActionController::Base
    include Pagy::Method
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_request_details

  helper_method :current_user, :signed_in?, :comparison_vehicle_slugs, :comparison_count

  private

  # Authentication (from authentication-zero)
  def authenticate
     if (session_record = Session.find_by_id(cookies.signed[:session_token]))
       Current.session = session_record
     else
       redirect_to new_session_path and return
     end
   end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
  end

  # Current user helper
  def current_user
    Current.user
  end

  def signed_in?
    current_user.present?
  end

  # Admin access
  def require_admin
    authenticate
    return if current_user&.admin_access?

    redirect_to root_path, alert: "Access denied.";
  end

  # Comparison helpers (session-based, no auth needed)
  def comparison_vehicle_slugs
    session[:comparison] ||= []
  end

  def comparison_count
    comparison_vehicle_slugs.size
  end
end
