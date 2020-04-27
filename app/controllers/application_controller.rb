class ApplicationController < ActionController::Base

  before_action :gon_user, unless: :devise_controller?
  
  def gon_user
    gon.user_id = current_user&.id
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization #unless: :devise_controller?
end
