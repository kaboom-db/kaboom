class AddPricePaidToCollectedIssue < ActiveRecord::Migration[7.1]
  def change
    add_column :collected_issues, :price_paid, :decimal, precision: 10, scale: 2, default: "0.0", null: false
  end
end
