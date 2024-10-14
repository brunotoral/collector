class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers do |t|
      t.integer :due_day, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_check_constraint :customers, "due_day >= 1 AND due_day <= 31", name: "due_day_range"
  end
end
