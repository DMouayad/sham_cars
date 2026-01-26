class ComparisonsController < ApplicationController
  MAX_COMPARISON = 4

  def show
    @vehicles = Vehicle.includes(:brand, :body_type, :images)
                       .where(slug: comparison_vehicle_slugs)

    @specs = comparison_specs if @vehicles.any?
  end

  def add
    slug = params[:slug]
    vehicle = Vehicle.friendly.find(slug)

    if comparison_vehicle_slugs.include?(vehicle.slug)
      flash[:notice] = "#{vehicle.full_name} is already in comparison."
    elsif comparison_vehicle_slugs.size >= MAX_COMPARISON
      flash[:alert] = "Maximum #{MAX_COMPARISON} vehicles can be compared."
    else
      comparison_vehicle_slugs << vehicle.slug
      flash[:notice] = "#{vehicle.full_name} added to comparison."
    end

    redirect_back fallback_location: vehicles_path
  end

  def remove
    slug = params[:slug]
    comparison_vehicle_slugs.delete(slug)

    flash[:notice] = "Vehicle removed from comparison."
    redirect_back fallback_location: comparison_path
  end

  def clear
    session[:comparison] = []

    flash[:notice] = "Comparison cleared."
    redirect_to vehicles_path
  end

  private

  def comparison_specs
    [
      { key: :price_display, label: "Price" },
      { key: :range_display, label: "Range (WLTP)" },
      { key: :battery_display, label: "Battery" },
      { key: :acceleration_display, label: "0-100 km/h" },
      { key: :top_speed_kmh, label: "Top Speed", suffix: " km/h" },
      { key: :horsepower, label: "Power", suffix: " hp" },
      { key: :torque_nm, label: "Torque", suffix: " Nm" },
      { key: :fast_charge_display, label: "Fast Charge" },
      { key: :drive_type, label: "Drive Type" },
      { key: :seats, label: "Seats" },
      { key: :cargo_volume_liters, label: "Cargo", suffix: " L" }
    ]
  end
end
