class Customer < User
	has_one :wallet
	has_many :transactions
	has_many :bookings, :dependent => :destroy
end
