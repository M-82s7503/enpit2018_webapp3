class TestMailer < ApplicationMailer
  default to: "yoshi.pellow.tomo@gmail.com"
  default from: "from@example.com"

  layout "mailer"

  def say_hello_test(user, project)
    if user.email == "e165738@ie.u-ryukyu.ac.jp"
      puts "\n   → メール送信"
      @user = user
      @project = project
      mail(to: @user.email, from:'from@example.com', subject: "HASが更新されました。")
    end
    # コミット数：0 になったプロジェクトに、メールを送る。
    if project.commit_num == 0
      puts "\n  → メール送信 (0なので)"
    end
  end
end
