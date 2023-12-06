class Booking < ApplicationRecord
  # Callback
  before_save :alphanumeric_id

  # Associations
  belongs_to :bus_route, foreign_key: :bus_route_id
  belongs_to :customer, foreign_key: :user_id
  belongs_to :bus, foreign_key: :bus_id
  belongs_to :drop_point, class_name: 'Location', foreign_key: :drop_point_id
  belongs_to :pickup_point, class_name: 'Location', foreign_key: :pickup_point_id

  # Scopes
  scope :searchquery, ->(parameter) do
    distinct.includes(:customer, :bus, :drop_point, :pickup_point, :bus_route)
      .where("status LIKE :search OR ticket_no LIKE :search OR (users.name) LIKE :search OR (buses.name) LIKE :search", search: "%#{parameter}%")
      .references(:customer, :bus)
  end

  scope :adminbook, -> { includes(:customer, :bus, :bus_route, :drop_point, :pickup_point, bus_route: [:from_city, :to_city]) }
  scope :customerbook, -> { includes(:customer, :bus, :bus_route, :drop_point, :pickup_point, bus_route: [:from_city, :to_city]) }

  # Enum
  enum status: { confirmed: "confirmed", pending: "pending", cancelled: "cancelled" }, _default: :pending

  def alphanumeric_id
    self.ticket_no = SecureRandom.urlsafe_base64(8)
  end

  def seat_update(bus, params, seats)
    bus.update(available_seats: seats - params[:booking][:seat_booked].to_i)
  end

  def wallet_update(wallet, params, fare)
    customer = wallet.customer
    booking_amt = params[:booking][:seat_booked].to_i * fare
    deduct = wallet.update(total_balance: wallet.total_balance - booking_amt)
    transaction = customer.transactions.build(description: "Booking Amount #{booking_amt} has deducted", amount: booking_amt)
    transaction.save
  end
end
