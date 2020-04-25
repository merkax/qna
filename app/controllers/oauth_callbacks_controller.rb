class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    #render json: request.env['omniauth.auth']
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
      redirect_to root_path, alert: 'something went wrong'
    end
  end
end
