class BusRoute < ApplicationRecord

  
  has_many :buses, :dependent => :destroy
  has_many :bookings, :dependent => :destroy

  belongs_to :from_city, class_name: 'City', foreign_key: :from_id
  belongs_to :to_city, class_name: 'City', foreign_key: :to_id


  
  private

  def date_must_not_be_in_past
    return if self.date.blank?
    if self.date < Date.today
      errors.add(:date, "can't be in the past")
    end
  end
end
