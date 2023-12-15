class BusesController < ApplicationController
  include AccessHelper
  before_action :set_bus_detail, only: [:show, :edit, :update, :destroy]
  before_action :reject_non_admins, except: [:index, :show]

  def index
    @buses = Bus.all
  end

  def new
    @bus = Bus.new
  end

  def create
    bus_route = BusRoute.find_by(id: params[:bus][:bus_route_id])
    @bus = bus_route.buses.build(bus_params)

    if @bus.save
      flash[:notice] = "Bus has been created successfully."
      redirect_to bus_routes_path
    else
      flash.now[:alert] = @bus.errors.full_messages
      render :new
    end
  end

  def update
    if @bus.update(bus_params)
      flash[:notice] = "Bus updated successfully."
      redirect_to bus_routes_path
    else
      flash.now[:error] = @bus.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @bus.destroy
      flash[:notice] = "Bus has been deleted successfully."
    else
      flash[:error] = @bus.errors.full_messages
    end

    redirect_to bus_routes_path
  end

  private

  def bus_params
    params.require(:bus).permit(:name, :number, :total_seats, :available_seats, :departure_time, :arrival_time, :fare, :bus_route_id)
  end

  def logged_in_user
    unless current_user
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end

  def set_bus_detail
    @bus = Bus.find_by_id(params[:id])
  end
end
