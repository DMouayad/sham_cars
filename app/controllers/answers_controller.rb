class AnswersController < ApplicationController
  def create
    @question = Question.published.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      track_event(action: "answer_create", eventable: @question)
      redirect_to @question
    else
      @question = Question.published.includes(:user, answers: :user).find(@question.id)
      render "questions/show", status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
