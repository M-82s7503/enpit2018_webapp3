class RemoveNameFromGithubCommitLogs < ActiveRecord::Migration[5.2]
  def change
    remove_column :github_commit_logs, :name, :string
  end
end
