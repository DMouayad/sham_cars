class HomeController < ApplicationController
    skip_before_action :require_authentication

  def index
     @featured_vehicles = Vehicle.includes(:brand, :body_type, :images)
                                .where(published: true, featured: true)
                                .ordered_by_newest
                                .limit(8)

    @brands = Brand.includes(:vehicles)
                   .with_published_vehicles
                   .ordered
                   .limit(12)

    @body_types = BodyType.ordered
  end
end
