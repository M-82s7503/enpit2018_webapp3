class Project < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :github_commit_logs, foreign_key: :project_id

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
    @new_commit_logs = JSON.parse(`curl https://api.github.com/repos/#{self.user.username}/#{name}/commits`)
    # webhook までのつなぎ。
    # 30までしか取得できないため、30以上は追加できない。
    added_commit_num = get_added_commit_num(@new_commit_logs)
    if added_commit_num > 0
      self.commit_num += added_commit_num
      # github_commit_log を差分更新
      save_commit_log(@new_commit_logs[0, added_commit_num])
    end
    save
  end


  def get_added_commit_num(commit_logs)
    return 0 if commit_logs.class != Array
    # 新 → 旧　の順。
    counter = 0
    for log in commit_logs do
      if log['sha'] == newest_commit_id
        puts "      ● self.newest_commit_id  :  #{newest_commit_id}"
        puts "      ●  log['sha']            :  #{log['sha']}"
        puts "      ●  added_commit_num      :  #{counter}"
        break
      end
      counter += 1
    end
    counter
  end

  def save_commit_log(commit_logs)
    return 0 if commit_logs.class != Array

    return if commit_logs.length.zero? # 空なら飛ばす。

    for log in commit_logs.reverse do
      params = choose_log_data(log)
      github_commit_logs = GithubCommitLog.new(params)
      github_commit_logs.save
    end
    # 最新（最初）の commit の id をメモする
    self.newest_commit_id = commit_logs[0]['sha']
    save
    puts("\nself.newest_commit_id（更新後） : #{newest_commit_id}\n\n\n")
  end

  def choose_log_data(log)
    # ここをいじると DB の内容が変わるので、github_commit_log を create し直す必要あり。
    #   → 一括更新するメソッド書いた：rake init_github_commit_log:init
    params = {}
    params['id'] = log['id'] # ?
    params['commit_id'] = log['sha']
    params['message'] = log['commit']['message'][0, 244] # 文字数上限を追加。
    params['users_id'] = user.id
    params['project_id'] = id
    # テスト用
    #params['name'] = log['committer']['date']
    params
  end
end
