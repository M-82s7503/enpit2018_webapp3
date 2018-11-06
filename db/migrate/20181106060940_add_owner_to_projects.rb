class AddOwnerToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :owner, :string, after: :name
  end
end
