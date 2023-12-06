class City < ApplicationRecord

	has_many :locations, :dependent => :destroy
	has_many :from_routes
  has_many :to_routes
end

