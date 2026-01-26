module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[edit update destroy]
    before_action :require_super_admin, only: [:destroy]

    def index
      @users = User.order(created_at: :desc)
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path, notice: "User updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @user == current_user
        redirect_to admin_users_path, alert: "Cannot delete yourself."
      else
        @user.destroy
        redirect_to admin_users_path, notice: "User deleted successfully."
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :role, :verified)
    end

    def require_super_admin
      unless current_user&.super_admin?
        redirect_to admin_users_path, alert: "Only super admins can delete users."
      end
    end
  end
end
