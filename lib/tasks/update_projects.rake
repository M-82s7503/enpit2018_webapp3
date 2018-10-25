namespace :update_projects do
    desc "GitHubからデータを取得して、データを更新。残コミ0ならメール。"
    # $ rake update_projects:update_and_mail 
    # で、実行できる。
    task update_and_mail: :environment do
        puts "Hello World"

        @users = User.all
        @users.each do |user|
            print "\n\n【", user.username, "】", user.email
            @projects = user.projects
            @projects.each do |project|
                print "\n・ ", project.name
                print "\n    interval : ", project.day_interval
                print "\n    eat_speed : ", project.goat_eat_speed
                project.update_commit_num(user, project)
                
                print "\n    commit_num : ", project.commit_num
                TestMailer.say_hello_test(user, project).deliver
            end
        end
    end
end
