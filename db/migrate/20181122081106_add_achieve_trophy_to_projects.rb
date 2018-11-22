class AddAchieveTrophyToProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :achieve_trophy, foreign_key: true
  end
end
