class RenameGithubProjectToProject < ActiveRecord::Migration[5.2]
  def change
    remove_reference :github_commit_logs, :github_projects, index: true, foreign_key: true
    rename_table :github_projects, :projects
  end
end
