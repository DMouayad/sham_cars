# app/controllers/admin/base_controller.rb

module Admin
  class BaseController < ApplicationController
    before_action :require_admin

    layout "admin"

    private

    def require_admin
      authenticate
      return if performed?  # Stop if authenticate already redirected
      return if current_user&.admin_access?

      redirect_to root_path, alert: "Access denied."
    end
  end
end
