class User < ApplicationRecord
  
  has_secure_password
  validates :email, presence: true, uniqueness: true
  VALID_PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[\W])(?=.*[\d])[\S]{8,15}\z/
  # validates :password,format: 
  #                     { 
  #                     with: VALID_PASSWORD_REGEX, 
  #                     message: 'should contain uppercase,
  #                     lowercase, number and special character. Between 8 and 15 characters long' 
  #                     }, 
  #                     allow_nil: true


  def is_customer?
    type == 'Customer'
  end

  def is_admin?
    type == 'Admin'
  end

  def welcome_amt
    ammount = 2000
    wallet = Wallet.create(customer_id: id, total_balance: ammount)
    customer = wallet.customer
    trans = customer.transactions.build(description: "Welcome Amount Added", amount: ammount)
    trans.save
  end
  
end