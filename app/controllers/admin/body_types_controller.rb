module Admin
  class BodyTypesController < BaseController
    before_action :set_body_type, only: %i[show edit update destroy]

    def index
      @body_types = BodyType.ordered
    end

    def show
    end

    def new
      @body_type = BodyType.new
    end

    def edit
    end

    def create
      @body_type = BodyType.new(body_type_params)

      if @body_type.save
        redirect_to admin_body_types_path, notice: "Body type created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @body_type.update(body_type_params)
        redirect_to admin_body_types_path, notice: "Body type updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @body_type.vehicles.exists?
        redirect_to admin_body_types_path, alert: "Cannot delete body type with vehicles."
      else
        @body_type.destroy
        redirect_to admin_body_types_path, notice: "Body type deleted successfully."
      end
    end

    private

    def set_body_type
      @body_type = BodyType.friendly.find(params[:id])
    end

    def body_type_params
      params.require(:body_type).permit(:name, :slug, :icon, :description)
    end
  end
end
