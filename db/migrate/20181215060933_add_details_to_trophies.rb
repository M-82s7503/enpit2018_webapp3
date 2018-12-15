class AddDetailsToTrophies < ActiveRecord::Migration[5.2]
  def change
    add_column :trophies, :trophy_condition, :string
  end
end
