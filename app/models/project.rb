class Project < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :github_commit_logs, foreign_key: :project_id

  belongs_to :user, foreign_key: :users_id

  # commit数：ヤギのエサの残数を更新する
  def update_commit_num()
    # ヤギが食べる
    if self.user.email == "e165738@ie.u-ryukyu.ac.jp"
      self.commit_num -= self.goat_eat_speed
    end
    # エサを追加
    #self.commit_num += get_added_commit_num(self.name)
    # 0以下は 0にする。
    if self.commit_num < 0
      self.commit_num = 0
    end
    self.save
  end
  

  private

  def get_added_commit_num()
    commit_logs = JSON.parse(`curl https://api.github.com/repos/#{current_user.username}/#{name}/commits`)
    # DB上の最新の commit_id をメモ

    # メモした commit_id が、上から何番目かを数える。
    # そこまでの commit_log を DB に追加する。
    if commit_logs.class != Array
      0
    else
      commit_logs.length
    end
  end
end
