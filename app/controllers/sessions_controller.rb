class SessionsController < ApplicationController
  
  skip_before_action :logged_in_user, only: [:create, :new] 
 
  def new
    if current_user.present?
      if current_user.type == 'Customer'
        redirect_to new_dashboard_path
      else
        redirect_to bus_routes_path
      end
    else
      render :new
    end
  end

  
    def create
      user = User.find_by(email: params[:email])   
     if user && user.authenticate(params[:password])   
        session[:user_id] = user.id
        if current_user.type == 'Customer'
          flash[:notice] = "Logged Inn..."
          redirect_to new_dashboard_path
        else
           redirect_to bus_routes_path
        end
      else
        #error message on fail
        flash[:error] = "Invalid username/ password combination."
        redirect_to root_path
      end
   end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have Been Signed Out."
    redirect_to root_url
  end
end



