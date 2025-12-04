class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :address
      t.string :city
      t.string :province
      t.string :postal_code

      t.timestamps
    end
  end
end
