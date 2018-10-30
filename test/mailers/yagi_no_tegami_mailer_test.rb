require 'test_helper'

class YagiNoTegamiMailerTest < ActionMailer::TestCase
  test "regular_mail" do
    mail = YagiNoTegamiMailer.regular_mail
    assert_equal "Regular mail", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "special_mail" do
    mail = YagiNoTegamiMailer.special_mail
    assert_equal "Special mail", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
