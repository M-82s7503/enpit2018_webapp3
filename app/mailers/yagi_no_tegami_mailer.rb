class YagiNoTegamiMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.yagi_no_tegami_mailer.regular_mail.subject
  #
  def regular_mail(user, project)
    @user = user
    @project = project
    # コミット数：0 になったプロジェクトに、メールを送る。
    if @project.commit_num == 0
        puts("          →  メール送信 (0なので)\n\n")
        @attach_name = 'ゴートの叫び.png'
        attachments.inline[@attach_name] = File.read("#{Rails.root}/app/assets/images/yagis/#{@attach_name}")
        mail(to: @user.email, from:'from@example.com', subject: "【HAS】Project : #{@project.name} のヤギから手紙が届きました！")
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.yagi_no_tegami_mailer.special_mail.subject
  #
  def special_mail
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
