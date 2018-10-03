class OmniauthCallbacksController < ApplicationController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))
    
    if @user.persisted?
      # flash.notice = "ログインしました！"
      # sign_in_and_redirect @user
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      # session["devise.user_attributes"] = @user.attributes
      # redirect_to new_user_registration_url
      session["devise.github_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  def failure
    redirect_to root_path
  end
end
