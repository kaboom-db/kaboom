class AddIndexesForRereadsAndReadIssues < ActiveRecord::Migration[8.1]
  def change
    add_index :read_issues, [:user_id, :issue_id, :read_at]

    add_index :comic_rereads,
      [:user_id, :comic_id, :reread_started_at],
      order: { reread_started_at: :desc }
  end
end
