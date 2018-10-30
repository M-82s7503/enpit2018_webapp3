class SessionsController < Devise::SessionsController
  def new
    redirect_to root_url
  end

  # def destroy
  #   super
  #   session[:keep_signed_out] = true # Set a flag to suppress auto sign in
  # end
end
