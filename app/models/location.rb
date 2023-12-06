class Location < ApplicationRecord
	belongs_to :city, foreign_key: :city_id
end