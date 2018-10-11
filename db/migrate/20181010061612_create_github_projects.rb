class CreateGithubProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :github_projects do |t|
      t.references :users, foreign_key: true
      t.string :name
      t.integer :commit_num
      t.timestamps
    end
  end
end
