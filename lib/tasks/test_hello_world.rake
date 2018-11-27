namespace :test_hello_world do
    desc "heroku 等で、rake taskを実行できるか確かめるための、テスト用スクリプト"
    # $ heroku run bundle exec rake test_hello_world:run
    # で実行できた。
    task run: :environment do
        puts "Hello! World.\n\n"
        @users = User.all
        @users.each do |user|
            puts "【#{user.username}】  #{user.email}"
            @projects = user.projects
            @projects.each do |project|
                puts "      ● #{project.name},   commit_num : #{project.commit_num}"
            end
        end
        puts
    end

    task :print_GitHubAPI_test do
        #print(`curl https://api.github.com/repos/M-82s7503/shrc/commits`)
        @commit_logs = JSON.parse(RestClient.get('https://api.github.com/repos/M-82s7503/shrc/commits'))
        # @commit_logs = JSON.parse(`curl https://api.github.com/repos/M-82s7503/shrc/commits`)
        #print(@commit_logs)

        for log in @commit_logs.reverse do
            #puts("log : #{log}\n\n")
            puts("\n\n\nlog['parents'] : #{log['parents']}")
            # => log['parents'] : [{"sha"=>"db63f3a3097df7d0cd4d342da11e710047a1f897", "url"=>"https://api.gith・・・・f897"}]

            # 空なら取得しない。
            if log['parents'] != []
                puts("log['parents'][0]['sha'] : #{log['parents'][0]['sha']}")
                puts("log['parents'][0]['url'] : #{log['parents'][0]['url']}")

                @c_diffs_url = log['parents'][0]['url']
                @commit_diffs = JSON.parse(RestClient.get(@c_diffs_url))
                @commit_diffs = JSON.parse(`curl #{@c_diffs_url}`)
                puts("\n@commit_diffs['stats'] : #{@commit_diffs['stats']}\n\n\n")
            end
        end
    end

end
