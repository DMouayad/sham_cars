class ReviewsController < ApplicationController
  before_action :set_vehicle

  def create
    @review = @vehicle.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to vehicle_path(@vehicle, anchor: "reviews"), notice: "Thank you for your review! It is pending approval."
    else
      # It's tricky to re-render the vehicle show page with errors.
      # A full-page reload with an error flash is simpler for now.
      flash[:alert] = @review.errors.full_messages.to_sentence
      redirect_to vehicle_path(@vehicle, anchor: "new-review")
    end
  end

  private

  def set_vehicle
    @vehicle = Vehicle.friendly.find(params[:vehicle_slug])
  end

  def review_params
    params.require(:review).permit(:rating, :title, :body)
  end
end
