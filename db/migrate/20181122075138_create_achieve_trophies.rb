class CreateAchieveTrophies < ActiveRecord::Migration[5.2]
  def change
    create_table :achieve_trophies do |t|
      t.references :trophy, foreign_key: true
      t.date :achieve_date

      t.timestamps
    end
  end
end
