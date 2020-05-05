class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :update, :destroy]
  
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end
  
  def new
  end
  
  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    @question.update(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    render json: { messages: 'Question was succesfully deleted.' }
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
