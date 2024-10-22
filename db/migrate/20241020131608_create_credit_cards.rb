class CreateCreditCards < ActiveRecord::Migration[7.2]
  def change
    create_table :credit_cards do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :token, null: false
      t.string :last_digits, null: false
      t.string :brand, null: false
      t.string :expiration_date, null: false

      t.timestamps
    end
  end
end
