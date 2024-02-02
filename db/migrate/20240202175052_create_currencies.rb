class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies do |t|
      t.string :symbol, null: false
      t.string :symbol_native, null: false
      t.string :name, null: false
      t.integer :decimal_digits
      t.integer :rounding
      t.string :name_plural

      t.timestamps
    end
  end
end
