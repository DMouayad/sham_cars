class VehiclesController < ApplicationController
  def index
    @q = Vehicle.includes(:brand, :body_type, :images)
                .where(published: true)
                .ransack(params[:q])

    @q.sorts = "created_at desc" if @q.sorts.empty?

    @pagy, @vehicles = pagy(@q.result(distinct: true))

    # For filter dropdowns
    @brands = Brand.with_published_vehicles.ordered
    @body_types = BodyType.ordered
  end

  def show
    @vehicle = Vehicle.includes(:brand, :body_type, :images)
                      .friendly
                      .find(params[:slug])

    # Related vehicles (same brand or body type)
    @related_vehicles = Vehicle.includes(:brand, :images)
                               .where(published: true)
                               .where.not(id: @vehicle.id)
                               .where(brand_id: @vehicle.brand_id)
                               .or(Vehicle.where(body_type_id: @vehicle.body_type_id))
                               .limit(4)
  end
end
