namespace :test_hello_world do
    desc "heroku 等で、実行できるか確かめるための、テスト用スクリプト"
    task run: :environment do
        puts "Hello! World.\n\n"
        @users = User.all
        @users.each do |user|
            puts "【#{user.username}】  #{user.email}"
        end
        puts
    end
end
