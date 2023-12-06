class TransactionsController < ApplicationController
  include AccessHelper
  before_action :logged_in_user
  before_action :reject_non_customer
  before_action :load_wallet

  def index
    @transactions = Transaction.eager_load(:customer).where(customer_id: current_user.id)
  end

  private

  def logged_in_user
    unless current_user
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end

  def reject_non_customer
    unless current_user&.is_customer?
      flash[:danger] = "Access denied. You are not a customer."
      redirect_to root_url
    end
  end

  def load_wallet
    @wallet_amt = current_user&.wallet if logged_in?
  end
end
