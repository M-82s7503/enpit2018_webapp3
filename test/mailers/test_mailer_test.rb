require 'test_helper'

class TestMailerTest < ActionMailer::TestCase
  test "say_hello_test" do
    mail = TestMailer.say_hello_test
    assert_equal "Say hello test", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
