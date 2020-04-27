class AwardsController < ApplicationController
  before_action :authenticate_user!, only: :index

  skip_authorization_check
  
  def index
    @awards = current_user.awards
  end
end
