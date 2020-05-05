class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: [:show, :update, :destroy]
  
  authorize_resource

  def index
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end
  
  def new
  end
  
  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def edit
  end
  
  def update
    @answer.update(answer_params)
    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    render json: { messages: 'Answer was succesfully deleted.' }
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
