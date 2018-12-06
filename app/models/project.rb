# coding: utf-8
class Project < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :github_commit_logs, foreign_key: :project_id
  has_many :achieve_trophy

  belongs_to :user, foreign_key: :users_id

  def update_count_and_check
    if day_counter.zero?
      self.day_counter = day_interval
      save!
    else
      self.day_counter -= 1
      save!
      false
    end
  end

  # commit数：ヤギのエサの量を更新する
  def update_commit_num
    ###  ヤギが食べる  ###
    self.commit_num -= goat_eat_speed

    ###  0以下は 0にする。  ###
    # 「食べられなかった」を再現するために、ここで0にする。
    self.commit_num = 0 if self.commit_num.negative?

    ###  エサを追加  ###
    @new_commit_logs = JSON.parse(RestClient.get('https://api.github.com/repos/' + owner + '/' + name + '/commits',
                              {:params => {:access_token => self.user.github_token}}))
    # @new_commit_logs = JSON.parse(`curl -H "Authorization: token #{self.user.github_token}" https://api.github.com/repos/#{owner}/#{name}/commits`)

    ###  追加分を取得  ###
    # webhook までのつなぎ。
    # 30以上も取得しようと思えばできるが、めんどくさくてやってない。
    added_commit_num = get_added_commit_num(@new_commit_logs, self.user.username)
    if added_commit_num > 0
      self.commit_num += added_commit_num
      # github_commit_log を差分更新
      save_commit_log(@new_commit_logs[0, added_commit_num])
    end
    save

    ###  トロフィー  ###
    check_achieve_trophy(added_commit_num)

    ###  定期メール  ###
    YagiNoTegamiMailer.regular_mail(user, self).deliver
  end


  def get_added_commit_num(commit_logs, name)
    return 0 if commit_logs.class != Array
    # 新 → 旧　の順。
    counter = 0
    for log in commit_logs do
      if log['sha'] == newest_commit_id
        puts "      ● self.newest_commit_id  :  #{newest_commit_id}"
        puts "      ●  commiter              :  #{log['commit']['committer']['name']}"
        puts "      ●  log['sha']            :  #{log['sha']}"
        puts "      ●  added_commit_num      :  #{counter}"
        break
      end
      counter += 1 if log['commit']['committer']['name'] == name
    end
    counter
  end

  def save_commit_log(commit_logs)
    return 0 if commit_logs.class != Array
    return if commit_logs.length.zero? # 空なら飛ばす。

    for log in commit_logs.reverse do
      params = choose_log_data(log)
      GithubCommitLog.create(params)
    end
    # 最新（最初）の commit の id をメモする
    self.newest_commit_id = commit_logs[0]['sha']
    save
    puts("\nself.newest_commit_id（更新後） : #{newest_commit_id}\n\n\n")
  end

  def choose_log_data(log)
    # ここをいじると DB の内容が変わるので、github_commit_log を create し直す必要あり。
    #   → 一括更新するメソッド書いた： $ rake init_github_commit_log:init
    params = {}
    params['id'] = log['id'] # ?
    params['commit_id'] = log['sha']
    params['message'] = log['commit']['message'][0, 244] # 文字数上限を追加。
    # 空なら取得しない。
    if log['parents'] != []
      @c_diffs_url = log['parents'][0]['url']
      # 差分情報を取得
      # @commit_diffs = JSON.parse(`curl -H "Authorization: token #{self.user.github_token}" #{@c_diffs_url}`)
      @commit_diffs = JSON.parse(RestClient.get(@c_diffs_url,
                                {:params => {:access_token => self.user.github_token}}))
      #puts(@commit_diffs)
      puts("\n      ● @commit_diffs['stats'] : #{@commit_diffs['stats']}\n\n")
      params['stats_total'] = @commit_diffs['stats']['total']
      params['stats_add'] = @commit_diffs['stats']['additions']
      params['stats_del'] = @commit_diffs['stats']['deletions']
    end
    params['users_id'] = user.id
    params['project_id'] = id
    return params
  end


  def check_achieve_trophy(added_commit_num)
    # テスト用データ
    #added_commit_num = 5
    puts("      ●  トロフィー 獲得状況")
    self.achieve_trophy.each do |ach_trophy|
      puts("            OK : #{ach_trophy.trophy.name}")
    end

    ## 未獲得のトロフィー一覧を出す。（ActiveRecode → Array への変換の意味も兼ねて）
    @unachieve_trophies = []
    @ach_trophy_ids = self.achieve_trophy.pluck(:trophy_id)
    @trophies = Trophy.all
    @trophies.each do |trophy|
      # 「獲得済み」を飛ばす
      next if @ach_trophy_ids.include?(trophy.id)
      next if trophy.name == '？'
      puts("            未 : #{trophy.name}")
      @unachieve_trophies.push(trophy)
    end
    
    ## トロフィー獲得条件を満たしたか確認する。
    @unachieve_trophies.each do |unach_trophy|
      # 通常のトロフィーが id==0 として登録される可能性はない。
      add_ach_trophy_id = 0

      case unach_trophy.name
      # 一度獲得すれば、↑の「獲得済み」を飛ばすで自動的に対象外になる。
      when '『はじめてのエサ』' then
        if added_commit_num > 0  #獲得条件
          add_ach_trophy_id = Trophy.find_by(name: '『はじめてのエサ』').id
          puts("        → トロフィー『はじめてのエサ』解放")
        end
      when '『エサの山！』' then
        if added_commit_num > 4
          add_ach_trophy_id = Trophy.find_by(name: '『エサの山！』').id
          puts("        → トロフィー『エサの山！』解放")
        end
      when '『落ち着きヤギ』' then
        t_id = Trophy.find_by(name: '『はじめてのエサ』').id
        # 『はじめてのエサ』 を取得済みかをまず確認。
        if self.achieve_trophy.exists?(:trophy_id => t_id)
          ach_trophy = self.achieve_trophy.find_by(:trophy_id => t_id)
          # 「コミットした」 かつ 「１日以上経っている」
          if added_commit_num > 0 && (Time.zone.now - ach_trophy.created_at) > 23.hour# - 1.day
          #if true  # テスト用
            add_ach_trophy_id = Trophy.find_by(name: '『落ち着きヤギ』').id
            puts("        → トロフィー『落ち着きヤギ』解放")
          end
        end
      end

      # 獲得条件が達成されたものは、achieve trophy に追加する。
      if add_ach_trophy_id != 0
        @new_trophy = AchieveTrophy.create!(
          trophy_id: add_ach_trophy_id,
          project_id: self.id,
        )
        ###  実績解除メール  ###
        YagiNoTegamiMailer.special_mail(user, self, Trophy.find(add_ach_trophy_id)).deliver
      end
    end
 
    puts
  end
end
