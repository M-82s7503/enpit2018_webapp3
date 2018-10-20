class AddColumnsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :goat_eat_speed, :integer, null: false, default: 1
    add_column :projects, :day_interval, :integer, null: false, default: 4
    add_column :projects, :day_counter, :integer, null: false, default: 0
  end
end
