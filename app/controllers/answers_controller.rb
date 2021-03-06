class AnswersController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:show, :update, :destroy, :set_best]
  after_action :publish_answer, only: :create
  
  authorize_resource

  def show
  end
  
  def new
  end
  
  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end
  
  def update
    @answer.update(answer_params)
    @question = @answer.question
  end
  
  def destroy
    @answer.destroy
  end
  
  def set_best
    @answer.set_best!
    @question = @answer.question
  end
  
  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
  
  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    
    ActionCable.server.broadcast(
                                "question_#{@question.id}_answers",
                                answer: @answer,
                                rating: @answer.rating,
                                links: @answer.links
      
    )
  end
end
