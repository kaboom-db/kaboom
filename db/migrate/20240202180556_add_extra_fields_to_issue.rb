class AddExtraFieldsToIssue < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :rating, :string
    add_column :issues, :cover_price, :decimal
    add_reference :issues, :currency, null: true, foreign_key: true
    add_column :issues, :page_count, :integer
    add_column :issues, :isbn, :string
    add_column :issues, :upc, :string
  end
end
