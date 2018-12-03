class AddColumnToTrophy < ActiveRecord::Migration[5.2]
  def change
    add_reference :trophies, :achieve_trophies, foreign_key: true
  end
end
