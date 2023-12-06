class BusRoutesController < ApplicationController

  include AccessHelper
  before_action :set_bus_routes, only: [:show, :edit, :update, :destroy]
  before_action :reject_non_admins
  
  def index
    @bus_routes = BusRoute.eager_load(:from_city, :to_city).all
  end

  def show
    @buses = @bus_routes.buses
  end
 
  def new
    @bus_route = BusRoute.new
    @cities = City.all
  end

  def create
    @bus_route = BusRoute.create(post_params)
    if @bus_route.save
      flash[:notice] = "Bus Details has been created successfully."
      redirect_to bus_routes_path
    else
      flash.now[:error] = @bus.errors.full_messages
      render :new
    end
  end

  def update
    if @bus_route.update(post_params)
      flash[:notice] = "BusRoute has been updated successfully."
      redirect_to new_bus_routes_path
    else
      flash.now[:error] = @bus.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @bus_routes.destroy
      flash[:notice] = "BusRoute has been Deleted successfully."
      redirect_to bus_route_path
    else
      flash[:error] = @bus.errors.full_messages
      redirect_to bus_routes_path
    end
  end

  private

  # Filter
  def set_bus_routes
    @bus_routes = BusRoute.find_by(id: params[:id])
  end

  def post_params 
    params.require(:bus_route).permit(:from_id, :to_id)
  end
  
end

