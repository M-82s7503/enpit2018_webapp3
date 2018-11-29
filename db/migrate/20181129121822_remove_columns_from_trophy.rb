class RemoveColumnsFromTrophy < ActiveRecord::Migration[5.2]
  def change
    remove_column :trophies, :mail_type, :string
  end
end
