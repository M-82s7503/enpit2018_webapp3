# coding: utf-8

class YagiNoTegamiMailer < ApplicationMailer

  ###  通常メール  ###
  def regular_mail(user, project)
    @user = user  # メール本文で使う
    @project = project
    mail_content = 0
    if @project.commit_num == 0
      # 「コミット数：0」
      # 『ゴートの叫び』を取得済みなら、ゴートの叫びもメールの候補に入れる。
      t_id = Trophy.find_by(name: '『ゴートの叫び』').id
      if @project.achieve_trophy.exists?(:trophy_id => t_id)
        mail_content = MailContent.no_feed.sample
      else
        mail_content = MailContent.no_feed.find_by(img_path: 'TrophyYagis/ゴートの叫び（マイルド）.png')
      end
    elsif @project.commit_num == -1  # こんな感じで増やしていく予定。（もう少しうまい方法がありそうだけど...。）
    end
    # メール送信
    if mail_content != 0
      puts("          →   通常メール 送信中...\n")
      send_mail(mail_content)
    end
  end

  ###  特殊メール  ###
  # とりあえず、今はトロフィーだけ。
  # また増えたら、メーラーを増やすか、ここを拡張するか考える。
  def special_mail(user, project, trophy_n)
    @user = user  # メール本文で使う
    @project = project
    @trophy = trophy_n
    @mail_content = MailContent.new(
      mail_type: -1,
      img_path: @trophy.img_path,
      sentence: @trophy.sentence
    )
    puts("          →   実績解除メール 送信中...\n")
    send_mail(@mail_content)
  end


  def send_mail(mail_content)
    #puts("mail_content.mail_type : #{mail_content.mail_type}")
    #puts("['no_feed', 'test_feed'].include? : #{['no_feed', 'test_feed'].include?(mail_content.mail_type)}")
    @attach_name = 'yagi_img.png'
    attachments.inline[@attach_name] = File.read("#{Rails.root}/app/assets/images/#{mail_content['img_path']}")
    @sentences = mail_content['sentence'].split('\n')

    ## メールデータ作成？
    mail(to: @user.email, from:'from@example.com', subject: "【HAS】Project : #{@project.name} のヤギから手紙が届きました！")
  end

end
