module ApplicationHelper
  
  def logged_in?
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in
    unless logged_in?
      flash[:notice] = "Please login"
      redirect_to root_path
    end
  end


  def flash_class(level)
    bootstrap_alert_class = {
    "success" => "alert-success",
    "error" => "alert-danger",
    "notice" => "alert-info",
    "alert" => "alert-danger",
    "warn" => "alert-warning"
    }
    bootstrap_alert_class[level]
  end  
end
