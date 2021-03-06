class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  authorize_resource
  
  def create
    @comment = commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end
  
  private

  def commentable
    klass = [Question, Answer].find { |k| params["#{k.name.underscore}_id"] }
    klass.find(params["#{klass.name.underscore}_id"])
  end

  def question_id
    if commentable.is_a?(Question)
      commentable.id
    else
      commentable.question.id
    end
  end

  def publish_comment
    return if @comment.errors.any?
    
    ActionCable.server.broadcast(
                                "question_#{question_id}_comments",
                                 comment: @comment
                                )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
