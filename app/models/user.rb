class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable, :omniauthable, omniauth_providers: [:github]

    def self.from_omniauth(auth)
        where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.email = auth.info.email
          user.password = Devise.friendly_token[0,20]
          user.username = auth.info.name # assuming the user model has a name
          # user.image = auth.info.image # assuming the user model has an image
          # If you are using confirmable and the provider(s) you use validate emails,
          # uncomment the line below to skip the confirmation emails.
          # user.skip_confirmation!
        end
        # sign_in_and_redirect user, event: :authentication
    end

    def self.new_with_session(params, session)
        if session["devise.user_attributes"]
            # new(session["devise.user_attributes"], without_protection: true) do |user|
            new(session["devise.user_attributes"]) do |user|
                user.attributes = params
                user.valid?
            end
        else
            super
        end
    end
end
