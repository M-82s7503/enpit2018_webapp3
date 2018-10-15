class RemoveAndAddGithubProjectFromGirhubCommitLog < ActiveRecord::Migration[5.2]
  def change
    add_reference :github_commit_logs, :project, index: true, foreign_key: true, after: :users_id
  end
end
