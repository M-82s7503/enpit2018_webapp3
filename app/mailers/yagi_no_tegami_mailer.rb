class YagiNoTegamiMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.yagi_no_tegami_mailer.regular_mail.subject
  #
  def regular_mail
    @greeting = "Hi"

    mail to: "to@example.org"
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
