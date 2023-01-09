class Polls::Questions::QuestionComponent < ApplicationComponent
  attr_reader :question
  delegate :auto_link_already_sanitized_html, :wysiwyg, to: :helpers #custom line

  def initialize(question:)
    @question = question
  end

  def answers_read_more_links
    safe_join(question.answers_with_read_more.map do |answer|
      link_to answer.title, "#answer_#{answer.id}"
    end, ", ")
  end
end
