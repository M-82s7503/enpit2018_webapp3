class RemoveImgFromTrophy < ActiveRecord::Migration[5.2]
  def change
    remove_column :trophies, :img, :binary
    remove_column :trophies, :img_type, :string
  end
end
