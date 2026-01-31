class VehiclesController < ApplicationController
    skip_before_action :require_authentication

    def index
      scope = Vehicle.includes(:brand, :body_type, :images).where(published: true)

      @q = scope.ransack(params[:q])
      @q.sorts = "created_at desc" if @q.sorts.empty?

      @pagy, @vehicles = pagy(@q.result(distinct: true))

      @brands = Brand.with_published_vehicles.ordered
      @body_types = BodyType.ordered
    end

  def show
    @vehicle = Vehicle.includes(:brand, :body_type, :images)
                      .friendly
                      .find(params[:slug])

    @reviews = @vehicle.approved_reviews.includes(:user).ordered_by_newest

    # Related vehicles (same brand or body type)
    @related_vehicles = Vehicle.includes(:brand, :images)
                               .where(published: true)
                               .where.not(id: @vehicle.id)
                               .where(brand_id: @vehicle.brand_id)
                               .or(Vehicle.where(body_type_id: @vehicle.body_type_id))
                               .limit(4)

    track_event(action: "vehicle_view", eventable: @vehicle)
  end
end
