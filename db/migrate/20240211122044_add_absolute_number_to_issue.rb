class AddAbsoluteNumberToIssue < ActiveRecord::Migration[7.0]
  def change
    add_column :issues, :absolute_number, :integer
  end
end
