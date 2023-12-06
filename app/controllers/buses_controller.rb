class BusesController < ApplicationController

  # Filter For the actions
  include AccessHelper
  before_action :set_bus_detail, only: [:show, :edit, :update, :destroy]
  before_action :reject_non_admins

  def index
    @buses = Bus.all
  end

  def new
    @bus = Bus.new
  end

  def create
    bus_route = BusRoute.find_by(id: params[:bus][:bus_route_id])
    @bus = bus_route.buses.create(bus_params)
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
      flash[:notice] = "Bus Updated"
      redirect_to  bus_routes_path
    else
      flash.now[:error] = @bus.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @bus.destroy
      flash[:notice] = "Bus has Deleted"
      redirect_to bus_route_path(bus_route_id: params[:bus_route_id])
    else
      flash[:error] = @bus.errors.full_messages
      redirect_to bus_route_path(bus_route_id: params[:bus_route_id])
    end
  end

  private

  def bus_params
    params.require(:bus).permit(:name, :number, :total_seats,:available_seats,:departure_time,:arrival_time,:fare,:bus_route_id)
  end

  def set_bus_detail
    @bus = Bus.find_by_id(params[:id])
  end

end
