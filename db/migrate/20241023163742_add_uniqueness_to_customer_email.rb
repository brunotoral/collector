class AddUniquenessToCustomerEmail < ActiveRecord::Migration[7.2]
  def change
    add_index :customers, :email, unique: true
  end
end
