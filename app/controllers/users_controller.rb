class UsersController < ApplicationController
  # 参考：https://qiita.com/tobita0000/items/866de191635e6d74e392
  #  before_action ~ で、ログイン済みのアカウントのみでしかアクセスできなくなる。
  before_action :authenticate_user!
  def index
    @projects = current_user.projects
  end

  def show; end
  def setting; end
end
