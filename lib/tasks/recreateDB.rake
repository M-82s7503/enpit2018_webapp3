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
                commit_logs = JSON.parse(RestClient.get('https://api.github.com/repos/' + project.owner + '/' + project.name + '/commits',
                                          {:params => {:access_token => user.github_token}}))
                # commit_logs = JSON.parse(`curl -H "Authorization: token #{user.github_token}" https://api.github.com/repos/#{project.owner}/#{project.name}/commits`)

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
                commit_logs = JSON.parse(RestClient.get('https://api.github.com/repos/' + project.owner + '/' + project.name + '/commits',
                                          {:params => {:access_token => user.github_token}}))
                # commit_logs = JSON.parse(`curl -H "Authorization: token #{user.github_token}" https://api.github.com/repos/#{project.owner}/#{project.name}/commits`)
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


    desc "Trophy と mail テーブルを初期化後、CSVデータを取り込む。"
    task :mail_and_trophy => :environment do
        Rake::Task["recreateDB:mail_and_trophy__delete_all"].invoke
        Rake::Task["recreateDB:trophy"].invoke
        Rake::Task["recreateDB:mail"].invoke
    end

    task :mail_and_trophy__delete_all => :environment do
        # 最初の１回のみ、トロフィーとメールのコンテンツを全削除する
        @trophies = Trophy.all
        @trophies.each do |trophy|
            # 削除しないtrophyの場合は 飛ばす。
            # next if trophy. != 
            print("  delete for trophy : #{trophy.id}:  #{trophy.name}\n")
            trophy.destroy()
        end
        puts
        @mails = MailContent.all
        @mails.each do |mail|
            # 削除しないmailの場合は 飛ばす。
            # next if mail. != 
            print("  delete for mail : #{mail.id}:  #{mail.mail_type}\n")
            mail.destroy()
        end
    end

    task :trophy => :environment do
        require 'csv'
        # CSV から取り込み
        puts("\n\n【Trophy テーブルにデータ取り込み中...】")
        @trophy_patterns = CSV.table("#{Rails.root}/app/assets/trophy_contents.csv")
        @trophy_patterns.each do |row|
            puts( "・#{row[:name]}" )
            puts( "    #{row[:img_path]}" )
            puts( "    #{row[:sentence]}" )
            # トロフィーを作成
            @trophy = Trophy.create!(
                name: row[:name],
                sentence: row[:sentence],
                img_path: row[:img_path]
            )
            # メールも同時に作成する
            # とりあえず、メール：トロフィー ＝ １：１ で。
            @mail =  MailContent.create!(
                mail_type: MailContent.mail_types['trophy'],
                contents_id: @trophy.id
            )
        end
    end

    task :mail => :environment do
        require 'csv'
        puts("\n\n【Mail データ取り込み中...】")
        # CSV から追加
        puts("MailContent.mail_types : #{MailContent.mail_types}")
        @mail_patterns = CSV.table("#{Rails.root}/app/assets/mail_contents.csv")
        @mail_patterns.each do |row|
            puts( "・#{row[:type]} : #{row[:title]}" )
            puts( "    #{row[:yagi_img]}" )
            puts( "    #{row[:yagi_message]}" )
            MailContent.create!(
                mail_type: row[:type],
                #name: row[:title],
                sentence: row[:yagi_message],
                img_path: row[:yagi_img],
                #trophy_id: Trophy.find_by(name:'dummy').id
            )
        end
    end

    task :achieve_trophy__delete_all => :environment do
        # 初期化
        AchieveTrophy.all.each do |ach_trophy|
            puts("ach_trophy: project_id, trophy_id = #{ach_trophy.project_id}, #{ach_trophy.trophy_id}")
            ach_trophy.destroy
        end
    end

end
