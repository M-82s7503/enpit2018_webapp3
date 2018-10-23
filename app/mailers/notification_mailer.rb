class NotificationMailer < ApplicationMailer
  default to: "yoshi.pellow.tomo@gmail.com"
  default from: "from@example.com"

  layout "mailer"

  def add_project_notification(project)
    @project = project
    @user = project.user
    mail(to: @user.email, from:'from@example.com', subject: "HASに新たなプロジェクトが追加されました")
  end

  def alert()
    mail(to: 'yoshi.pellow.tomo@gmail.com', subject: 'テスト確認メール')
  end
end
