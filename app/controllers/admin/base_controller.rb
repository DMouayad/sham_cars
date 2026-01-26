
module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :require_admin
    # before_action :require_sudo

    private

    def require_admin
      if Current.user.blank?
        redirect_to sign_in_path, alert: t("application.require_admin.must_be_signed_in")
      else
        redirect_to root_path, alert: t("application.require_admin.not_authorized") unless current_user&.admin_access?
      end
    end
    # def require_admin
    #   authenticate
    #   return if performed?  # Stop if authenticate already redirected
    #   return if current_user&.admin_access?

    #   redirect_to root_path, alert: "Access denied."
    # end
  end
end
