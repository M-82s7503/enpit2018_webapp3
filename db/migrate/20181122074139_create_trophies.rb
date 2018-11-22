class CreateTrophies < ActiveRecord::Migration[5.2]
  def change
    create_table :trophies do |t|
      t.string :name
      t.string :sentence
      t.binary :img, limit: 10.megabyte # <= limit を指定する
      t.string :img_type

      t.timestamps
    end
  end
end
