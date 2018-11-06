class NotificationMailer < ApplicationMailer

  def add_project_notification(project)
    @project = project
    @user = project.user
    @attach_name = 'Mojiyagi.png'
    attachments.inline[@attach_name] = File.read("#{Rails.root}/app/assets/images/#{@attach_name}")
    mail(to: @user.email, from:'from@example.com', subject: "HASに新たなプロジェクトが追加されました")
  end

  def alert()
    mail(to: 'yoshi.pellow.tomo@gmail.com', subject: 'テスト確認メール')
  end
end
