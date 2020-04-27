class FindForOauthService
  attr_reader :auth
  
  def initialize(auth)
    @auth = auth
  end
  
  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization


    email = auth.info[:email]
    return unless email

    user = User.find_or_create_by(email: email) do |u|
      password = Devise.friendly_token[0, 20]
      u.password = password
      u.password_confirmation = password
      u.confirmed_at = Time.now
    end
    user.authorizations.create!(provider: auth.provider, uid: auth.uid)

    user
  end
end

