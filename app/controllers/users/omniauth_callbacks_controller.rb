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
    # remember_me(user)
    session_code = request.env['rack.request.query_hash']['code']
    state = request.env['rack.request.query_hash']['state']
    require 'rest-client'
    require 'json'
    # # ... and POST it back to GitHub
    result = RestClient.post('https://github.com/login/oauth/access_token',
                            {client_id: client_id,
                             client_secret: client_secret,
                             code: session_code,
                             state: state},
                             accept: :json)
    access_token = JSON.parse(result)['access_token']
    logger.debug(session_code)
    logger.debug(result)
    logger.debug(access_token)
    # sign_in_and_redirect user, event: :authentication
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
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
