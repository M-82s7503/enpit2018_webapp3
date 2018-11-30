class AddColumnToAchieveTrophy < ActiveRecord::Migration[5.2]
  def change
    add_reference :achieve_trophies, :project, foreign_key: true
  end
end
