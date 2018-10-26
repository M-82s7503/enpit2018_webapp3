namespace :recreate_github_commit_log do
    desc "実行処理の説明"
    task :run => :environment do
        # project を初期化
        projects_controller = ProjectsController.new()

        @users = User.all
        @users.each do |user|
            print("\n【#{user.username}】  #{user.email}\n")
            @projects = user.projects
            @projects.each do |project|
                # 一旦削除
                project.github_commit_logs.destroy_all()
                # 取得し直す
                projects_controller.save_commit_log(user, project)
            end
        end
    end
end
