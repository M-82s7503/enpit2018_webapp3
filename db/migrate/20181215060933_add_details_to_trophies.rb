class AddDetailsToTrophies < ActiveRecord::Migration[5.2]
  def change
    add_column :trophies, :condition, :string
  end
end
