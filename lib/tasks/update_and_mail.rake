namespace :update_and_mail do
    desc "github_commit_log を差分更新して、メールを送る。Heroku の定期スクリプト"
    # $ bundle exec rake update_and_mail:run
    # で、実行できる。
    task run: :environment do
        @users = User.all
        @users.each do |user|
            puts("\n\n【#{user.username}】  #{user.email}")
            @projects = user.projects
            @projects.each do |project|
                puts "\n==================  Projact : #{project.name}  =================="
                puts "      ● goat_eat_speed : #{project.goat_eat_speed}"
                puts "      ● interval : #{project.day_interval}"
                puts "      ● day_counter : #{project.day_counter}"
                project.update_commit_num()
                
                puts "      ● 現在の エサの量 : #{project.commit_num}"
                TestMailer.say_hello_test(user, project).deliver
            end
            puts
        end
        puts
    end
end