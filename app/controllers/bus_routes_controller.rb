class BusRoutesController < ApplicationController
  include AccessHelper
  before_action :set_bus_route, only: [:show, :edit, :update, :destroy]
  before_action :reject_non_admins
  
  def index
    @bus_routes = BusRoute.eager_load(:from_city, :to_city).all
  end

  def show
    @buses = @bus_route.buses
  end
 
  def new
    @bus_route = BusRoute.new
    @cities = City.all
  end

  def create
    @bus_route = BusRoute.new(bus_route_params)

    if @bus_route.save
      flash[:notice] = "Bus Details has been created successfully."
      redirect_to bus_routes_path
    else
      flash.now[:error] = @bus_route.errors.full_messages
      @cities = City.all
      render :new
    end
  end

  def update
    if @bus_route.update(bus_route_params)
      flash[:notice] = "BusRoute has been updated successfully."
      redirect_to bus_routes_path
    else
      flash.now[:error] = @bus_route.errors.full_messages
      @cities = City.all
      render :edit
    end
  end

  def destroy
    if @bus_route.destroy
      flash[:notice] = "BusRoute has been deleted successfully."
    else
      flash[:error] = @bus_route.errors.full_messages
    end

    redirect_to bus_routes_path
  end

  private

  def set_bus_route
    @bus_route = BusRoute.find_by(id: params[:id])
  end

  def bus_route_params 
    params.require(:bus_route).permit(:from_id, :to_id)
  end

  def logged_in_user
    unless current_user
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end
end
