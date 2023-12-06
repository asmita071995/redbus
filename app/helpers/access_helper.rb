module AccessHelper
	private
  def reject_non_admins
    unless current_user.is_admin?
      flash[:alert] = "Sorry!!! Only Admin can Access this page."
      redirect_to root_path and return
    end
  end

  private
  def reject_non_customer
    unless current_user.is_customer?
      flash[:alert] = "Sorry!!! Only Customer can Access this page."
      redirect_to root_path and return
    end
  end
end