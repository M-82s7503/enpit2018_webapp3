namespace :update_projects do
    desc "GitHubからデータを取得して、データを更新。残コミ0ならメール。"
    # $ rake update_projects:update_and_mail 
    # で、実行できる。
    task update_and_mail: :environment do
        puts "Hello World"
        Rake::Task["update_projects:update_commit_logs"].invoke()
    end

    task update_commit_logs: :environment do
        @users = User.all
        @users.each do |user|
            print "\n【", user.username, "】\n"
            @projects = user.projects
            @projects.each do |project|
                puts project.name
                Rake::Task["update_projects:add_commit_num"].invoke(user, project)
                Rake::Task["update_projects:goat_eat_commit"].invoke(user, project)
                Rake::Task["update_projects:send_mail"].invoke(user, project)
            end
        end
    end

    task :add_commit_num, ['user', 'proj'] => :environment do |t, args|
        #args.user, args.proj
        args.proj.commit_num -= args.proj.goat_eat_speed
        args.proj.save
    end

    task :goat_eat_commit, ['user', 'proj'] => :environment do |t, args|
        
    end

    task :send_mail, ['user', 'proj'] => :environment do |t, args|
        # コミット数：0 になったプロジェクトに、メールを送る。
        if args.proj.commit_num == 0
            #puts "メールを送ります！"
            TestMailer.say_hello_test(args.user, args.proj).deliver
        end
    end
end
