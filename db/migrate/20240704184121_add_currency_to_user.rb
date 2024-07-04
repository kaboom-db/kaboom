class AddCurrencyToUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :currency, null: true, foreign_key: true
  end
end
