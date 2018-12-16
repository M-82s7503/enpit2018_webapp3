class AddDetailsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :commit_sum, :integer, default:0
    add_column :projects, :sprint_continue_tmp, :integer, default:0
    add_column :projects, :sprint_continue_record, :integer, default:0
  end
end
