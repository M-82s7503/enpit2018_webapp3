namespace :recreate_DB do
    desc "DBの内容に変更が入って、取得し直したいときに使う。 github_commit_logs の全データを再取得（createし直し）する。"
    task :github_commit_log => :environment do
        # github_commit_logs を再構築する。
        @users = User.all
        @users.each do |user|
            print("\n【#{user.username}】  #{user.email}\n")
            @projects = user.projects
            @projects.each do |project|
                # 一旦削除
                project.github_commit_logs.destroy_all()
                # 取得し直す
                project.save_commit_log(user, project)
            end
        end
    end
end
