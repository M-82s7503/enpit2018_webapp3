class AddMailTypeToTrophy < ActiveRecord::Migration[5.2]
  def change
    add_column :trophies, :img_path, :string, default:'TrophyYagis/futu_yagi.png', null:false
    add_column :trophies, :mail_type, :integer, default:0, null:false
  end
end
