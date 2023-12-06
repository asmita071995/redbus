class CreateUser < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
     t.string :name
     t.string :email
     t.string :password_digest
     t.string :type
     t.string :role
     t.string :mobile_no

      t.timestamps
    end
  end
end
