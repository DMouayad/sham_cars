class ApplicationController < ActionController::Base
    include Pagy::Method

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_request_details
  before_action :authenticate
  before_action :require_authentication

  helper_method :current_user, :signed_in?, :comparison_vehicle_slugs, :comparison_count

  private
    def authenticate
      if session_record = Session.find_by_id(cookies.signed[:session_token])
        Current.session = session_record
      end
    end

    def require_authentication
      redirect_to sign_in_path unless Current.session
    end

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end

    def set_user
      @user = Current.user
    end

    def require_sudo
      unless Current.session.sudo?
        redirect_to new_sessions_sudo_path(proceed_to_url: request.original_url)
      end
    end
  
    # Current user helper
    def current_user
      Current.user
    end

    def signed_in?
      current_user.present?
    end
    def require_admin
      if Current.user.blank?
        redirect_to sign_in_path, alert: t("application.require_admin.must_be_signed_in")
      else
        redirect_to root_path, alert: t("application.require_admin.not_authorized") unless Current.user.admin?
      end
    end

    # Comparison helpers (session-based, no auth needed)
    def comparison_vehicle_slugs
      session[:comparison] ||= []
    end

    def comparison_count
      comparison_vehicle_slugs.size
    end
end
