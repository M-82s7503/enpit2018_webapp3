class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # @user = User.from_omniauth(request.env["omniauth.auth"])
    # auth = request.env['omniauth.auth']
    #
    # user = User.find_or_create_by(
    #   provider: auth.provider,
    #   uid: auth.uid
    # )
    @user = User.from_omniauth(request.env["omniauth.auth"])

    adka
    # remember_me(user)

    # sign_in_and_redirect user, event: :authentication
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      # session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
    # if @user.persisted?
    #   flash.notice = "ログインしました！"
    #   sign_in_and_redirect @user
    # else
    #   session["devise.user_attributes"] = @user.attributes
    #     redirect_to new_user_registration_url
    # end
  end

  def failure
    redirect_to root_path
  end
end
