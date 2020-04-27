class ConfirmationsController < Devise::ConfirmationsController
  def new
  end

  def create
    user = User.find_or_initialize_by(email: params[:user][:email]) do |u|
      password = Devise.friendly_token[0, 20]
      u.password = password
      u.password_confirmation = password
    end

    if user.persisted?
      user.authorizations.create!(provider: session["devise.provider"], uid: session["devise.uid"])

      sign_in(user)
      redirect_to root_path and return
    end

    if user.save
      user.send_confirmation_instructions and return
    else
      render :new, alert: 'email wrong'
    end
  end

  private

  def after_confirmation_path_for(_resource_name, user)
    if session.key?('devise.provider') && session.key?('devise.uid')
      user.authorizations.create!(provider: session["devise.provider"], uid: session["devise.uid"])
    end

    sign_in(user)
    root_path
  end
end
