class TestMailer < ApplicationMailer
  default to: "yoshi.pellow.tomo@gmail.com"
  default from: "from@example.com"

  layout "mailer"

  def say_hello_test(user, project)
    @user = user
    # テスト用
    if @user.email == "e165738@ie.u-ryukyu.ac.jp"
      # コミット数：0 になったプロジェクトに、メールを送る。
      if project.commit_num == 0
        print "\n        →  メール送信 (0なので)"
      else
        print "\n        →  メール送信"
        @project = project
        @attach_name = 'futu_yagi.png'
        attachments.inline[@attach_name] = File.read("#{Rails.root}/app/assets/images/yagis/#{@attach_name}")
        mail(to: @user.email, from:'from@example.com', subject: "HASが更新されました。")
      end
    end
  end
end
