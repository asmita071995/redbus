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
      bus_route = bus.bus_route_id
      if bus.nil?
      	flash[:notice] = "Bus Not Available"
      else
      	seats = bus.available_seats
        redirect_to new_booking_path(from_id: params[:booking][:from_id], to_id: params[:booking][:to_id], bus_id: params[:booking][:bus_id]),
        flash: { alert: "only#{seats} seats availbable" }

        assert_no_difference "Model.count" do
        return if seats < params[:booking][:seat_booked].to_i
        booking = Booking.new(book_params)
        booking.bus_route_id = bus.bus_route_id
      end

      	booking.user_id = current_user.id
      	if booking.save
      	   booking.seat_update(bus, params, seats)
      	   redirect_to (bookings_path)
      	else
      	  flash[:notice] = 'Booking Failed'	
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
    booking.cancelled! #update enum by default method using
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





