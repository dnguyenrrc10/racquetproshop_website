class CreatePriceHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :price_histories do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :old_price, precision: 10, scale: 2
      t.decimal :new_price, precision: 10, scale: 2
      t.datetime :changed_at

      t.timestamps
    end
  end
end
