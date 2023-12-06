class UsersController < ApplicationController

  include ApplicationHelper
  skip_before_action :logged_in_user, only:[:new, :create]

  def new
    @user = User.new
  end 

  def create

       
    @user = Customer.new(user_params)  
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages
      redirect_to new_user_path
    end
  end


  def show
  	@user = User.find_by(id: params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password_digest, :password, :mobile_no )
  end

end
