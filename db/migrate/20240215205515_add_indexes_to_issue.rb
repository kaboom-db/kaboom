class AddIndexesToIssue < ActiveRecord::Migration[7.0]
  def change
    remove_index :issues, [:absolute_number, :comic_id], unique: true
    add_index :issues, [:issue_number, :comic_id], unique: true
  end
end
