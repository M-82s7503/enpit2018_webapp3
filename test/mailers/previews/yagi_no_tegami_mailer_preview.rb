# Preview all emails at http://localhost:3000/rails/mailers/yagi_no_tegami_mailer
class YagiNoTegamiMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/yagi_no_tegami_mailer/regular_mail
  def regular_mail
    user = User.second
    YagiNoTegamiMailer.regular_mail(user, user.projects.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/yagi_no_tegami_mailer/special_mail
  def special_mail
    YagiNoTegamiMailer.special_mail
  end

end
