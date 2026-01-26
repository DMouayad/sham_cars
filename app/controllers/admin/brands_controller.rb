module Admin
  class BrandsController < BaseController
    before_action :set_brand, only: %i[show edit update destroy]

    def index
      @brands = Brand.includes(:vehicles).ordered
    end

    def show
      @vehicles = @brand.vehicles.includes(:body_type).ordered_by_newest
    end

    def new
      @brand = Brand.new
    end

    def edit
    end

    def create
      @brand = Brand.new(brand_params)

      if @brand.save
        redirect_to admin_brands_path, notice: "Brand created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @brand.update(brand_params)
        redirect_to admin_brands_path, notice: "Brand updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @brand.vehicles.exists?
        redirect_to admin_brands_path, alert: "Cannot delete brand with vehicles."
      else
        @brand.destroy
        redirect_to admin_brands_path, notice: "Brand deleted successfully."
      end
    end

    private

    def set_brand
      @brand = Brand.friendly.find(params[:id])
    end

    def brand_params
      params.require(:brand).permit(:name, :slug, :logo, :country, :description, :website)
    end
  end
end
