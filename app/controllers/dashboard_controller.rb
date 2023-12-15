class DashboardController < ApplicationController
  
  before_action :logged_in_user
  include ApplicationHelper 

  def index 
   redirect_to new_dashboard_path, flash: {alert: "Cities can't be same" } and return if params[:from_id]==params[:to_id]
    if params[:date] < (Date.today).to_s
    	flash[:alert] = "Past Dates not allowed"
      redirect_to new_dashboard_path
    else
      bus_route = BusRoute.where(bus_params)
      @buses = @buses = Bus.where("bus_route_id IN (SELECT id FROM bus_routes WHERE from_id = ? AND to_id = ?) AND DATE(departure_time) = ?", params[:from_id], params[:to_id], params[:date])

	  end
  end	


	def new
		@city = City.order(:name).pluck(:name,:id)
	end

	private



  def logged_in_user
    unless current_user
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end
  
  def bus_params
    params.permit(:from_id, :to_id)
  end
end 
		  

		  







