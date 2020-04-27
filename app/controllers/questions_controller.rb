class QuestionsController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end
  
  def show
    @answer = @question.answers.new
    @answer.links.new
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end
  
  def new
    @question = Question.new
    @question.links.new
    @question.build_award
  end
  
  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.owner?(@question)
  end
  
  def destroy
    @question.destroy if current_user.owner?(@question)
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                    links_attributes: [:id, :name, :url, :_destroy],
                                    award_attributes: [:id, :name, :image, :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
