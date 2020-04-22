class ApplicationController < ActionController::Base

  before_action :gon_user#, unless: :devise_controller? добавить?

  def gon_user
    gon.user_id = current_user&.id
  end
end
