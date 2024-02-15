class ChangeIssueNumberToString < ActiveRecord::Migration[7.0]
  def change
    change_column :issues, :issue_number, :string
    add_index :issues, [:absolute_number, :comic_id], unique: true
    remove_index :issues, [:issue_number, :comic_id], unique: true
  end
end
