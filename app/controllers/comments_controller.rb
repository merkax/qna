class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  def create
    @comment = commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  private

  def commentable
    klass = [Question, Answer].find { |k| params["#{k.name.underscore}_id"] }
    klass.find(params["#{klass.name.underscore}_id"])
  end

  def question_id
    commentable.class == Question ? commentable.id : commentable.question.id #question_id
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
