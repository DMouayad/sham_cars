class QuestionsController < ApplicationController
  skip_before_action :require_authentication, only: [:index, :show]

  def index
    @questions = Question.published
                         .includes(:user)
                         .order(created_at: :desc)
                         .limit(50)
  end

  def show
    @question = Question.published
                        .includes(:user, answers: :user)
                        .find(params[:id])

    @question.increment!(:views_count)
    track_event(action: "question_view", eventable: @question)

    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    @question.status = :published

    if @question.save
      track_event(action: "question_create", eventable: @question)
      redirect_to @question
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
