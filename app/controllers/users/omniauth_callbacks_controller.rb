class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    # result = RestClient.post('https://github.com/login/oauth/access_token',
    #                         {client_id: client_id,
    #                          client_secret: client_secret,
    #                          code: session_code,
    #                          state: state},
    #                          accept: :json)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to home_path
  end
end
