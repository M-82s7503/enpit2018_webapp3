class AddDetailsToGithubCommitLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :github_commit_logs, :stats_total, :integer
    add_column :github_commit_logs, :stats_add, :integer
    add_column :github_commit_logs, :stats_del, :integer
  end
end
