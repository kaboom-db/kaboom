class CreateReadIssues < ActiveRecord::Migration[7.0]
  def change
    create_table :read_issues do |t|
      t.datetime :read_at, null: false
      t.references :user, null: false, foreign_key: true
      t.references :issue, null: false, foreign_key: true

      t.timestamps
    end
  end
end
