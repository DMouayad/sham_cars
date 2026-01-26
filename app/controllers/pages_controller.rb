class PagesController < ApplicationController
  def home
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

  def about
  end
end
