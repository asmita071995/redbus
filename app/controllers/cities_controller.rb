class CitiesController < ApplicationController
  
  include AccessHelper
  
  before_action :set_city, only: [:new, :edit, :update, :destroy, :show]
  before_action :reject_non_admins

  def index
    @cities = City.all
  end

  def new
    @city = City.new
  end

  def create
    @city = City.create(city_params)
    if @city.save
      flash[:notice] = "City Created"
      redirect_to cities_path
    else 
      flash.now[:error] = @city.errors.full_messages
      render :new
    end
  end

  def update
    if @city.update(city_params)
      flash[:notice] = "Update Done"
      redirect_to cities_path 
    else
      flash.now[:error] = @city.errors.full_messages
      render :edit 
    end
  end

  def destroy
    if @city.destroy
      flash[:notice] = "City Destroyed"
      redirect_to locations_path
    else 
      flash[:error] = @city.errors.full_messages
      redirect_to locations_path
    end
  end

  private 
  def city_params
    params.require(:city).permit(:id, :name)
  end

  
  def set_city
    @city = City.find_by(id: params[:id])
  end

end

