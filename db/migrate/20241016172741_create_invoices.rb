class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :invoices do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :payment_method, null: false
      t.date :due_date, null: false
      t.integer :status, null: false, default: 0
      t.string :comment

      t.timestamps
    end
  end
end
