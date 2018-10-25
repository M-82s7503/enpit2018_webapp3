class Project < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :github_commit_logs, foreign_key: :project_id

  belongs_to :user, foreign_key: :users_id

  def update_commit_num(user, project)
    # ヤギが食べる
    project.commit_num -= project.goat_eat_speed
    # エサを追加
    project.save
  end

end
