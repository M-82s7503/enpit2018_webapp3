class TestMailer < ApplicationMailer
  default to: "yoshi.pellow.tomo@gmail.com"
  default from: "from@example.com"

  layout "mailer"

  def say_hello_test(user)
    if user.email == "e165738@ie.u-ryukyu.ac.jp"
      puts "メールを送ります！"
      @user = user
      @project = user.projects
      mail(to: @user.email, from:'from@example.com', subject: "HASが更新されました。")
    end
  end
end
