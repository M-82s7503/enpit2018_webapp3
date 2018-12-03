class RenameMailToMailContent < ActiveRecord::Migration[5.2]
  def change
    rename_table :mails, :mail_contents
  end
end
