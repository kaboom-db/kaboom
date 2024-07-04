class RemoveCoverPriceAndCurrencyFromIssues < ActiveRecord::Migration[7.1]
  def change
    remove_column :issues, :cover_price, :decimal
    remove_reference :issues, :currency, null: false, foreign_key: true
  end
end
