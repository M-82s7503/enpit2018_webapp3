namespace :update_projects do
    desc "GitHubからデータを取得して、データを更新。残コミ0ならメール。"
    # $ rake update_projects:update_and_mail 
    # で、実行できる。
    task update_and_mail: :environment do
        puts "Hello World"
        @users = User.all

        @users.each do |user|
            print "\n【", user.username, "】\n"
            @projects = user.projects
            @projects.each do |project|
                puts project.name
            end
            TestMailer.say_hello_test(user).deliver
            #UserMailer.say_hello(user).deliver
        end
    end
end
