class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: [:create]#, :update
  before_action :find_answer, only: [:show, :update, :destroy, :set_best]

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
    @answer.update(answer_params) if current_user.owner?(@answer)
    @question = @answer.question
  end
  
  def destroy
    @answer.destroy if current_user.owner?(@answer)
  end
  
  def set_best
    @answer.set_best! if current_user.owner?(@answer.question)
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
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
