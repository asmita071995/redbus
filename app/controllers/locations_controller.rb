class LocationsController < ApplicationController

  include AccessHelper
  before_action :set_locations, only: [:show, :edit, :update, :destroy]
  before_action :reject_non_admins

  def index
    @locations = Location.where(city_id: params[:city_id])
  end

  def new
    @location = Location.new
  end

  def create
    city = City.find_by(id: params[:location][:city_id])
    @location = city.locations.create(location_param)
    if @location.save
      flash[:notice] = "Location has been created successfully."
      redirect_to cities_path
    else
      flash.now[:alert] = @location.errors.full_messages
      render :new
    end
  end

  def update
    if @location.update(point: params[:location][:point])
      flash[:notice] = "Location Updated"
      redirect_to locations_path
    else 
      flash.now[:error] = @location.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @location.destroy
      flash[:notice] = "Location has Deleted"
      redirect_to locations_path
    else 
      flash.now[:error] = @location.errors.full_messages
      redirect_to cities_path
    end
  end

  def set_locations
    @location = Location.find_by(id: params[:id])
  end 

  private 
  def location_param
    params.require(:location).permit(:id, :point, :city_id)
  end
  
end

