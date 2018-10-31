class YagiNoTegamiMailer < ApplicationMailer

  def regular_mail(user, project)
    @user = user
    @project = project
    # コミット数：0 になったプロジェクトに、メールを送る。
    if @project.commit_num == 0
        puts("          →  メール送信 (0なので)\n\n")
        @attach_name = select_random_mail_image(0)
        attachments.inline[@attach_name] = File.read("#{Rails.root}/app/assets/images/yagis/#{@attach_name}")
        mail(to: @user.email, from:'from@example.com', subject: "【HAS】Project : #{@project.name} のヤギから手紙が届きました！")
    end
  end
  # mail_pattarn に従って、画像をランダムに選ぶ
  def select_random_mail_image(mail_pattarn)
    @img_list_table = CSV.table('mail_image_lists.csv')
  end


  def special_mail
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
