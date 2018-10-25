namespace :update_projects do
    desc "GitHubからデータを取得して、データを更新。残コミ0ならメール。"
    # $ rake update_projects:update_and_mail 
    # で、実行できる。
    task update_and_mail: :environment do
        @users = User.all
        @users.each do |user|
            print "\n【", user.username, "】", user.email
            @projects = user.projects
            @projects.each do |project|
                print "\n・ ", project.name
                print "\n    goat_eat_speed : ", project.goat_eat_speed
                print "\n    interval : ", project.day_interval
                print "\n    day_counter : ", project.day_counter
                project.update_commit_num(user, project)
                
                print "\n    commit_num : ", project.commit_num
                TestMailer.say_hello_test(user, project).deliver
            end
            puts
        end
        puts
    end
end
