class AwardsController < ApplicationController
  before_action :authenticate_user!, only: :index

  def index
    @awards = current_user.awards
  end
end
