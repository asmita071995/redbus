class BookingsController < ApplicationController
   
  before_action :logged_in_user

  def index
    if current_user.is_admin?
      @bookings = Booking.adminbook.searchquery(params[:search])
    else
      @bookings = Booking.customerbook.where(user_id: current_user.id).searchquery(params[:search])
    end
  end

  def new
    @bus = Bus.find_by(id: params[:bus_id])
    @booking = Booking.new
    @from_locations = City.find(params[:from_id]).locations
    @to_locations = City.find(params[:to_id]).locations
  end

  def show 
   @booking = Booking.find_by(id: params[:id])
 end

  def create
   bus = Bus.find_by(id: params[:booking][:bus_id])
    if bus.nil?
      flash[:alert] = "Bus Not Available"
      redirect_to new_booking_path(from_id: params[:booking][:from_id], to_id: params[:booking][:to_id], bus_id: params[:booking][:bus_id])
    else
      seats = bus.available_seats
    return redirect_to new_booking_path(from_id: params[:booking][:from_id], to_id: params[:booking][:to_id], bus_id: params[:booking][:bus_id]),
                                     flash: { alert: "Only #{seats} seats available" } if seats < params[:booking][:seat_booked].to_i

      @booking = Booking.new(book_params)
      @booking.bus_route_id = bus.bus_route_id
      @booking.user_id = current_user.id

      if @booking.save
        @booking.seat_update(bus, params, seats)
        flash[:notice] = 'Booking successful.'
        redirect_to bookings_path
      else
        flash.now[:error] = @booking.errors.full_messages
        render :new
      end
    end
  end
  def confirm 
    booking = Booking.find_by(id: params[:id])
    seat_book = booking.seat_booked
    wallet = Wallet.find_by(customer_id: booking.user_id)
    if wallet.nil?
      flash[:notice] = "Add Wallet Amount"
      redirect_to bookings_path
    else
      balance = wallet.total_balance
      fare = booking.bus.fare.to_i
      if balance>seat_book*fare
         booking.wallet_update(wallet, params, fare)
      	 booking.confirmed!
      	 redirect_to bookings_path
      else
        flash[:notice] = "Wallet Amount is less"
      	redirect_to bookings_path
      end
   end
  end


  def refund
    bookings = Booking.where("created_at < ? OR status = ?", Date.today, "cancelled").where.not("status=?", "confirmed")
    if bookings.nil?
      flash[:alert] = "No Bookings for refund"
      redirect_to refund_path
    else  
        bookings.each do |booking|
          customer = booking.customer
          total_balance = customer.wallet.total_balance
          seat_booked = booking.seat_booked
          fare = booking.bus.fare
          refund_amount = seat_booked*fare
          customer.wallet.update(total_balance: total_balance + refund_amount)
          transaction = customer.transactions.build(description: "Booking Amount #{refund_amount} has
          refunded", amount: refund_amount)
          transaction.save
          if booking.destroy
            flash[:notice] = "Cancel and previous date bookings deleted."
            redirect_to bookings_path
          else
            flash[:alert] = bookings.errors.full_messages
            redirect_to bookings_path  
          end 
        end
    end
  end

  def cancel
    booking = Booking.find_by(id: params[:id])
    booking.cancelled! 
    redirect_to bookings_path
  end

  private
  def book_params
    params.require(:booking).permit(:seat_booked,:bus_id,:pickup_point_id,
    :drop_point_id,:date)
  end 



  def logged_in_user
    unless current_user
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end
end





