class HomeController < ApplicationController
  skip_before_action :require_authentication

  def index
    @body_types = BodyType.ordered
    @selected_body_type = BodyType.find_by(id: params[:body_type_id])

    # Community sections
    @latest_questions = Question.published
                                .includes(:user)
                                .order(created_at: :desc)
                                .limit(6)

    @latest_reviews = Review.includes(:user, vehicle: [:brand, :images])
                            .order(created_at: :desc)
                            .limit(6)

    # Brands (optional section)
    @brands = Brand.includes(:vehicles)
                   .with_published_vehicles
                   .ordered
                   .limit(12)

    # Scopes for "Discover"
    featured_scope = Vehicle.includes(:brand, :body_type, :images)
                            .where(published: true, featured: true)
                            .ordered_by_newest

    trending_ids = Event.where(action: "vehicle_view", eventable_type: "Vehicle")
                        .where("created_at > ?", 7.days.ago)
                        .group(:eventable_id)
                        .order(Arel.sql("COUNT(*) DESC"))
                        .limit(50)
                        .count
                        .keys

    trending_scope = Vehicle.includes(:brand, :body_type, :images)
                            .where(published: true, id: trending_ids)

    recommended_scope = nil
    if current_user
      viewed_ids = Event.where(user: current_user, action: "vehicle_view", eventable_type: "Vehicle")
                        .order(created_at: :desc)
                        .limit(50)
                        .pluck(:eventable_id)

      if viewed_ids.any?
        body_type_counts = Vehicle.where(id: viewed_ids).group(:body_type_id).count
        preferred_body_type_ids = body_type_counts.sort_by { |_, c| -c }.map(&:first).take(2)

        recommended_scope = Vehicle.includes(:brand, :body_type, :images)
                                   .where(published: true, body_type_id: preferred_body_type_ids)
                                   .where.not(id: viewed_ids)
                                   .order(average_rating: :desc, reviews_count: :desc)
      end
    end

    discover_scope =
      if recommended_scope.present?
        @discover_source = :recommended
        recommended_scope
      elsif trending_ids.any?
        @discover_source = :trending
        trending_scope
      else
        @discover_source = :featured
        featured_scope
      end

    if @selected_body_type
      discover_scope = discover_scope.where(body_type_id: @selected_body_type.id)
    end

    @discover_vehicles = discover_scope.limit(8)

    # Turbo Frame: only update discover section when chips are clicked
    if turbo_frame_request?
      render partial: "home/discover_vehicles_frame",
             locals: { vehicles: @discover_vehicles, source: @discover_source }
    end
  end
end
