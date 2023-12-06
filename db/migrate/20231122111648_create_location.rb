class CreateLocation < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
     t.string :point
     t.integer :city_id


      t.timestamps
    end
  end
end
