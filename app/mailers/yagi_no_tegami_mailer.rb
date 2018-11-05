require 'csv'

class YagiNoTegamiMailer < ApplicationMailer

  def regular_mail(user, project)
    @user = user
    @project = project
    @mail_patterns = CSV.table("#{Rails.root}/app/mailers/mail_patterns.csv")
    # コミット数：0 になったプロジェクトに、メールを送る。
    if @project.commit_num == 0
        puts("          →   (0なので)メール送信中...\n\n")
        mail_pattern = select_random_mail_pattern(@mail_patterns, 0)
        #puts "mail_pattern : #{mail_pattern}"  #=> mail_pattern : 0,ゴートの叫び（マイルド）.png,ヤギはふとエサ箱を覗くとエサがなくなっていた。どうにかしなければならないとヤギにもわかったが、不安を押さえきれずただただ叫んだ。
        #puts "mail_pattern[:yagi_img] : #{mail_pattern[:yagi_img]}"  #=> @attach_name : ゴートの叫び（マイルド）.png
        @attach_name = mail_pattern[:yagi_img]
        attachments.inline[@attach_name] = File.read("#{Rails.root}/app/assets/images/yagis/#{@attach_name}")
        mail(to: @user.email, from:'from@example.com', subject: "【HAS】Project : #{@project.name} のヤギから手紙が届きました！")
    end
  end
  # mail_type に従って、画像をランダムに選ぶ
  def select_random_mail_pattern(mail_patterns, mail_type)
    # mail_type に合致するパターンを抽出する。(とりあえず簡単に実装) 増えてきたら DB に移行で。
    # 参考：
    #   https://qiita.com/hkengo/items/59ba599ef48c613f2402
    #   https://shikiyura.stars.ne.jp/blog/programming/ruby_csv-handle/
    @mail_patterns = mail_patterns
    mailp_arr = []
    #puts "\n@mail_patterns : #{@mail_patterns}\n\n"
    @mail_patterns.each do |row|
      #print "row[:type] : #{row[:type]}"
      if row[:type] == mail_type
        mailp_arr << row  # 追加
        #print "  # added"
      end
      #puts
    end
    #puts "mailp_arr : #{mailp_arr}"
    # ランダムに１つ取り出して返す。
    return mailp_arr.sample
  end


  def special_mail
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
