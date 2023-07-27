class PollsController < ApplicationController
  include FeatureFlags
  include PollsHelper

  feature_flag :polls

  before_action :load_poll, except: [:index]
  before_action :load_active_poll, only: :index

  load_and_authorize_resource

  # has_filters %w[current expired]
  has_orders %w[most_voted newest oldest], only: :show

  def index
    @polls = Kaminari.paginate_array(
      @polls.created_by_admin.not_budget.send(@current_filter).includes(:geozones).sort_for_list(current_user)
    ).page(params[:page])
  end

  def show
    if !@poll.projekt.visible_for?(current_user)
      @individual_group_value_names = @poll.projekt.individual_group_values.pluck(:name)
      render "custom/pages/forbidden", layout: false
    end

    @questions = @poll.questions.for_render.sort_for_list
    @token = poll_voter_token(@poll, current_user)
    @poll_questions_answers = Poll::Question::Answer.where(question: @poll.questions)
                                                    .with_content.order(:given_order)

    @answers_by_question_id = {}

    @questions.each do |question|
     @answers_by_question_id[question.id] = []
    end

    poll_answers = ::Poll::Answer.by_question(@poll.question_ids).by_author(current_user&.id)
    poll_answers.each do |answer|
      @answers_by_question_id[answer.question_id] = @answers_by_question_id.has_key?(answer.question_id) ? @answers_by_question_id[answer.question_id].push(answer.answer) : [answer.answer]
    end

    @commentable = @poll
    @comment_tree = CommentTree.new(@commentable, params[:page], @current_order)
  end

  def stats
    @stats = Poll::Stats.new(@poll)
  end

  def results
  end

  private

    def load_poll
      @poll = Poll.find_by_slug_or_id!(params[:id])
    end

    def load_active_poll
      @active_poll = ActivePoll.first
    end
end
