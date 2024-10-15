class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :street, null: false
      t.string :number
      t.string :city, null: false
      t.string :state, null: false
      t.string :zipcode, null: false
      t.string :supplement
      t.string :district, null: false

      t.timestamps
    end
  end
end
