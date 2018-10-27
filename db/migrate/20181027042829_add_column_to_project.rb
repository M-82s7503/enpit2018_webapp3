class AddColumnToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :newest_commit_id, :string
  end
end
