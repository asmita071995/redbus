class CreateWallet < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
     t.string :total_balance
     t.string :available_balance
     t.integer :customer_id

      t.timestamps
    end
  end
end
