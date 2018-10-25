namespace :update_projects do
    desc "GitHubからデータを取得して、データを更新。残コミ0ならメール。"
    # $ rake update_projects:update_and_mail 
    # で、実行できる。
    task update_and_mail: :environment do
        puts "Hello World"
        Rake::Task["update_projects:update"].invoke()
    end

    task update: :environment do
        @users = User.all
        @users.each do |user|
            print "\n【", user.username, "】\n"
            @projects = user.projects
            @projects.each do |project|
                puts project.name
                Project.update_commit_num(user, project)
                #Rake::Task["update_projects:update_commit_num"].invoke(user, project)
                print "    commit_num : ", project.commit_num, "\n"
                TestMailer.say_hello_test(user, proj).deliver
                #Rake::Task["update_projects:send_mail"].invoke(user, project)
            end
        end
    end


    task :update_commit_num, ['user', 'proj'] => :environment do |t, args|
    end

    task :send_mail, ['user', 'proj'] => :environment do |t, args|
    end
end
