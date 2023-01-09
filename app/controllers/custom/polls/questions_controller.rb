require_dependency Rails.root.join("app", "controllers", "polls", "questions_controller").to_s

class Polls::QuestionsController < ApplicationController

  def answer
    answer = @question.find_or_initialize_user_answer(current_user, params[:answer])
    answer.answer_weight = params[:answer_weight].presence || 1
    answer.save_and_record_voter_participation

    unless providing_an_open_answer?(answer)
      @answer_updated = "answered"
    end

    render "polls/questions/answers"
  end

  def update_open_answer
    answer = @question.answers.find_or_initialize_by(author: current_user, answer: open_answer_params[:answer])
    if answer.update(open_answer_text: open_answer_params[:open_answer_text])
      @open_answer_updated = true
    end
    render "polls/questions/answers"
  end

  private

  def open_answer_params
    params.require(:poll_answer).permit(:answer, :open_answer_text)
	end

  def providing_an_open_answer?(answer)
    @question.open_question_answer.present? && @question.open_question_answer.title == answer.answer
  end
end
