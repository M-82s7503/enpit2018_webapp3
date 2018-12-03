# coding: utf-8

class YagiNoTegamiMailer < ApplicationMailer

  def regular_mail(user, project)
    @project = project
    # コミット数：0 になったプロジェクトに、メールを送る。
    if @project.commit_num == 0
      puts("          →   (0なので)メール送信中...\n\n")
      send_mail(user, project, MailContent.no_feed.sample)
    elsif @project.commit_num == -1  # こんな感じで増やしていく予定。（もう少しうまい方法がありそうだけど...。）
      puts("          →   (0なので)メール送信中...\n\n")
      send_mail(user, project, MailContent.test_feed.sample)
    end
  end

  def send_mail(user, project, mail_pattern)
    @attach_name = 'yagi_img_attach.png'
    attachments.inline[@attach_name] = File.read("#{Rails.root}/app/assets/images/#{mail_pattern['img_path']}")
    #puts("attachments  attachments")
    @sentences = mail_pattern['sentence'].split('\n')
    @user = user  # メール本文で使う
    mail(to: user.email, from:'from@example.com', subject: "【HAS】Project : #{project.name} のヤギから手紙が届きました！")
  end


  def special_mail
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
