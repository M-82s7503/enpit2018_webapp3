class UsersController < ApplicationController
  # 参考：https://qiita.com/tobita0000/items/866de191635e6d74e392
  #  before_action ~ で、ログイン済みのアカウントのみでしかアクセスできなくなる。
  before_action :authenticate_user!
  def index
    @projects = current_user.projects
  end

  def show; end
  def setting; end


  def destroy
    print("\n  delete for user : #{current_user.username}  #{current_user.email}\n")
    @projects = current_user.projects
    @projects.each do |project|
      # 削除
      print("\n    project : #{project}    delete \n")
      project.github_commit_logs.destroy_all()
      project.delete()
    end
    current_user.delete()
    redirect_to home_path
  end

end
