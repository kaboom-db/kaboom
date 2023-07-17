class CreateCollectedIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :collected_issues do |t|
      t.references :user, null: false, foreign_key: true
      t.references :issue, null: false, foreign_key: true
      t.date :collected_on

      t.timestamps
    end

    add_index :collected_issues, [:user_id, :issue_id], unique: true
  end
end
