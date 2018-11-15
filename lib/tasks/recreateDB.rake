namespace :recreateDB do
    desc "DBの内容に変更が入って、取得し直したいときに使う。"
    task :github_commit_log => :environment do
        # github_commit_logs を再構築する。
        # ※ commit_num は初期化されない。
        @users = User.all
        @users.each do |user|
            print("\n【#{user.username}】  #{user.email}\n")
            @projects = user.projects
            @projects.each do |project|
                # 一旦削除
                project.github_commit_logs.destroy_all()
                # 取得し直す
                # stats も取得すると、Projectの数によっては一発でアクセス制限にかかるので注意。
                # ※ 一応、回避方法もないわけではなさそう？ → https://developer.github.com/v3/#rate-limiting
                puts("URL  :  https://api.github.com/repos/#{project.owner}/#{project.name}/commits")
                commit_logs = JSON.parse(`curl -H "Authorization: token #{user.github_token}" https://api.github.com/repos/#{project.owner}/#{project.name}/commits`)

                puts commit_logs
                project.save_commit_log(commit_logs)
            end
        end
    end

    task :project => :environment do
        # project を再構築する。
        # ※ commit_num も、初期化される。
        @users = User.all
        @users.each do |user|
            print("\n【#{user.username}】  #{user.email}")
            @projects = user.projects
            @projects.each do |project|
                puts("\n=================  #{project.name}  ===================")
                proj_name = project.name
                # 一旦削除
                project.github_commit_logs.destroy_all()
                project.delete()

                # 作り直す
                # project create (あとで統一したい。)
                project = Project.new()
                project.name = proj_name
                project.users_id = user.id
                commit_logs = JSON.parse(`curl -H "Authorization: token #{user.github_token}" https://api.github.com/repos/#{project.owner}/#{project.name}/commits`)
                # commit_logs = JSON.parse(`curl -H "Authorization: token #{user.github_token}" https://api.github.com/repos/#{project.owner}/#{project.name}/commits`)
                # get_commit_num()
                if commit_logs.class != Array
                    project.commit_num = 0
                else
                    project.commit_num = commit_logs.length #上限30
                end
                if project.save
                  project.save_commit_log(commit_logs)
                  #NotificationMailer.add_project_notification(project).deliver_now
                end
            end
            puts
        end
    end

    task :project_delete_all => :environment do
        # 全ユーザーの全プロジェクトを削除・初期化する。
        @users = User.all
        @users.each do |user|
            print("\n【#{user.username}】  #{user.email}\n")
            @projects = user.projects
            @projects.each do |project|
                proj_name = project.name
                # 削除
                project.github_commit_logs.destroy_all()
                project.delete()
            end
        end
    end
end
