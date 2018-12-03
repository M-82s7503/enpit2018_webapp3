class CreateMails < ActiveRecord::Migration[5.2]
  def change
    create_table :mails do |t|
      t.integer :mail_type, null:false
      t.string :img_path
      t.string :sentence
      t.integer :contents_id, default:-9  # 使わないときは -9 になる。

      t.timestamps
    end
  end
end
