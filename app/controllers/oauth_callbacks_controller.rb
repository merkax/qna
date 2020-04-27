class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    authorize('github')
  end

  def vkontakte
    authorize('vkontakte')
  end

  private

  def authorize(provider)
    auth_data = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth_data)
    
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      session["devise.provider"] = auth_data.provider
      session["devise.uid"] = auth_data.uid

      redirect_to new_user_confirmation_path
    end
  end
end
