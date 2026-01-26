class BrandsController < ApplicationController
  def index
    @brands = Brand.includes(:vehicles)
                   .with_published_vehicles
                   .ordered
  end

  def show
    @brand = Brand.friendly.find(params[:slug])

    @q = @brand.vehicles
               .includes(:body_type, :images)
               .where(published: true)
               .ransack(params[:q])

    @q.sorts = "year desc" if @q.sorts.empty?

    @pagy, @vehicles = pagy(@q.result(distinct: true))
  end
end
