class Project < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :github_commit_logs, foreign_key: :project_id

  belongs_to :user, foreign_key: :users_id

  def update_commit_num(user, project)
    # ヤギが食べる
    if user.email == "e165738@ie.u-ryukyu.ac.jp"
      project.commit_num -= project.goat_eat_speed
    end
    # エサを追加
    # 0以下は 0にする。
    if project.commit_num < 0
      project.commit_num = 0
    end
    project.save
  end

end
