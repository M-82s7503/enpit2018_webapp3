namespace :test_hello_world do
    desc "heroku 等で、rake taskを実行できるか確かめるための、テスト用スクリプト"
    # $ heroku run bundle exec rake test_hello_world:run
    # で実行できた。
    task run: :environment do
        puts "Hello! World.\n\n"
        @users = User.all
        @users.each do |user|
            puts "【#{user.username}】  #{user.email}"
        end
        puts
    end
end
