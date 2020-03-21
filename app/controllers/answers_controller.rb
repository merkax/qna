class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :find_question, only: :create
  before_action :find_answer, only: [:show, :destroy]

  def show
   # @answer = @question.answer
  end
  
  def new
  end
  
  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end
  
  def destroy
    @answer.destroy if current_user.owner?(@answer)
    redirect_to @answer.question
  end
  
  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
  
  def answer_params
    params.require(:answer).permit(:body)
  end
end
