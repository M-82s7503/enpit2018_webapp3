class UsersController < ApplicationController
  # 参考：https://qiita.com/tobita0000/items/866de191635e6d74e392
  #  before_account 〜 で、ログイン済みのアカウントのみでしかアクセスできなくなる。
  before_action :authenticate_user!
  def index
  end

  def show
  end

end
