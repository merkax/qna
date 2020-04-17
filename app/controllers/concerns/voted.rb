module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote_up, :vote_down, :vote_cancel]
  end

  def vote_up
    return render_errors if current_user.owner?(@votable)

    @votable.vote_up(current_user)
    render_json
  end

  def vote_down
    return render_errors if current_user.owner?(@votable)

    @votable.vote_down(current_user)
    render_json
  end

  def vote_cancel
    return render_errors if current_user.owner?(@votable)

    @votable.vote_cancel(current_user)
    render_json
  end

  private

  def render_json
    render json: {  id: @votable.id,
                    name: param_name(@votable),
                    rating: @votable.rating } 
  end
  
  def render_errors
    render json: { message: "Error: Author cannot vote for himself" },
                   status: :forbidden
  end
  
  def param_name(item)
    item.class.name.underscore
  end
  
  def model_klass
    controller_name.classify.constantize
  end
  
  def load_votable
    @votable = model_klass.find(params[:id])
  end
end
