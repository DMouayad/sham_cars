module Admin
  class VehiclesController < BaseController
    before_action :set_vehicle, only: %i[show edit update destroy publish unpublish toggle_featured]
    before_action :set_form_collections, only: %i[new edit create update]

    def index
      base = Vehicle.includes(:brand, :body_type, :images)

      params[:q] ||= {}
      @q = base.ransack(params[:q])

      @q.sorts = default_sort if @q.sorts.empty?
      @pagy, @vehicles = pagy(@q.result(distinct: true))

      @brands = Brand.ordered
      @body_types = BodyType.ordered
    end

     def show
       @related_vehicles = Vehicle.includes(:brand, :images)
                                  .where(published: true)
                                  .where.not(id: @vehicle.id)
                                  .where(brand_id: @vehicle.brand_id)
                                  .or(Vehicle.where(body_type_id: @vehicle.body_type_id, published: true).where.not(id: @vehicle.id))
                                  .limit(4)
     end

    def new
      @vehicle = Vehicle.new
    end

    def edit
    end

    def create
      @vehicle = Vehicle.new(vehicle_params)

      if @vehicle.save
        redirect_to admin_vehicle_path(@vehicle), notice: "Vehicle created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @vehicle.update(vehicle_params)
        redirect_to admin_vehicle_path(@vehicle), notice: "Vehicle updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @vehicle.destroy
      redirect_to admin_vehicles_path, notice: "Vehicle deleted successfully."
    end

    def publish
      @vehicle.update(published: true)
      redirect_back fallback_location: admin_vehicles_path, notice: "Vehicle published."
    end

    def unpublish
      @vehicle.update(published: false)
      redirect_back fallback_location: admin_vehicles_path, notice: "Vehicle unpublished."
    end

    def toggle_featured
      @vehicle.update(featured: !@vehicle.featured)
      status = @vehicle.featured? ? "featured" : "unfeatured"
      redirect_back fallback_location: admin_vehicles_path, notice: "Vehicle #{status}."
    end

    private

    def set_vehicle
      @vehicle = Vehicle.includes(:brand, :body_type, :images).friendly.find(params[:id])
    end

    def set_form_collections
      @brands = Brand.ordered
      @body_types = BodyType.ordered
    end

    def vehicle_params
      params.require(:vehicle).permit(
        :brand_id, :body_type_id, :name, :slug, :description, :year, :status,
        :price_from, :price_to, :currency,
        :battery_capacity_kwh, :range_wltp_km, :range_epa_miles, :efficiency_wh_km,
        :acceleration_0_100, :top_speed_kmh, :horsepower, :torque_nm, :drive_type,
        :fast_charge_kw, :fast_charge_time_min, :home_charge_kw, :charge_port,
        :length_mm, :width_mm, :height_mm, :wheelbase_mm, :weight_kg,
        :cargo_volume_liters, :seats,
        :featured, :published
      )
    end

     def default_sort
       case params[:sort]
       when "price_asc"
         "price_from asc"
       when "price_desc"
         "price_from desc"
       when "range"
         "range_wltp_km desc"
       else
         "created_at desc"
       end
     end
end
end
