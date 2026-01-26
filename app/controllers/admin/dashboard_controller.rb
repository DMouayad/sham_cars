module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        vehicles_count: Vehicle.count,
        published_count: Vehicle.where(published: true).count,
        brands_count: Brand.count,
        body_types_count: BodyType.count,
        users_count: User.count
      }

      @recent_vehicles = Vehicle.includes(:brand)
                                .order(created_at: :desc)
                                .limit(5)
    end
  end
end
