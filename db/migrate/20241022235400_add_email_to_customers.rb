class AddEmailToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :email, :string, null: false
  end
end
