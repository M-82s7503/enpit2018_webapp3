class CreateGithubCommitLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :github_commit_logs do |t|
      t.references :users, foreign_key: true
      t.references :github_projects, foreign_key: true
      t.string :name
      t.string :commit_id
      t.string :message
      t.integer :size
      t.timestamps
    end
  end
end
