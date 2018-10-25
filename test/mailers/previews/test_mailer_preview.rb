# Preview all emails at http://localhost:3000/rails/mailers/test_mailer
class TestMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/test_mailer/say_hello_test
  def say_hello_test
    TestMailer.say_hello_test
  end

end
