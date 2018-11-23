# coding: utf-8

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

    task :project__delete_all => :environment do
        # 全ユーザーの全プロジェクトを削除・初期化する。
        @users = User.all
        @users.each do |user|
            print("\n【#{user.username}】  #{user.email}\n")
            @projects = user.projects
            @projects.each do |project|
                # 削除
                project.github_commit_logs.destroy_all()
                project.delete()
            end
        end
    end

    desc "引数で、削除したいユーザーのユーザー名を指定する。"
    task :user__delete_one, ['name'] => :environment do |task, args|
        # 引数で指定したユーザーの全プロジェクトを削除・初期化し、その後、ユーザー情報も削除する。
        @users = User.all
        @users.each do |user|
            # ユーザー名が違う場合は 飛ばす。
            next if user.username != args[:name]
            print("\n  delete for user : #{user.username}  #{user.email}\n")
            @projects = user.projects
            @projects.each do |project|
                # 削除
                print("\n    project : #{project}    delete \n")
                project.github_commit_logs.destroy_all()
                project.delete()
            end
            user.delete()
        end
    end


    desc "CSV を Trophy テーブルに取り込む。"
    task :trophies => :environment do
        require 'csv'

        @trophies = Trophy.all
        @trophies.each do |trophy|
            # 削除しないtrophyの場合は 飛ばす。
            # next if trophy. != 
            print("  delete for trophy : #{trophy.id}:  #{trophy.name}\n")
            trophy.delete()
        end

        @mail_patterns = CSV.table("#{Rails.root}/app/assets/mail_contents.csv")
        @mail_patterns.each do |row|
            puts
            puts( "#{row[:type]} : #{row[:title]}" )
            puts( "#{row[:yagi_message]}" )
            puts( "#{row[:yagi_img]}" )
            Trophy.create!(
                mail_type: row[:type],
                name: row[:title],
                sentence: row[:yagi_message],
                img_path: row[:yagi_img]
            )
        end
        puts
    end

end
