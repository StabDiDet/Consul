module Abilities
  class Everyone
    include CanCan::Ability

    def initialize(user)
      can [:read, :map], Debate
      can [:read, :map, :summary, :share, :json_data], Proposal
      can :read, Comment
      can :read, Poll
      can [:results, :stats], Poll do |poll|
        (user&.administrator? || user&.moderator?) &&
          ProjektSetting.find_by(projekt: poll.projekt, key: "projekt_feature.polls.intermediate_poll_results_for_admins").value.present?
      end
      can :results, Poll, id: Poll.expired.results_enabled.not_budget.ids
      can :stats, Poll, id: Poll.expired.stats_enabled.not_budget.ids
      can :read, Poll::Question
      can :read, User
      can [:read, :welcome], Budget
      can [:read], Budget
      can [:read], Budget::Group
      can [:read, :print, :json_data], Budget::Investment
      can :read_results, Budget, id: Budget.finished.results_enabled.ids
      can :read_stats, Budget, id: Budget.valuating_or_later.stats_enabled.ids
      can :read_executions, Budget, phase: "finished"
      can :new, DirectMessage
      can [:read, :debate, :draft_publication, :allegations, :result_publication,
           :proposals, :milestones], Legislation::Process, published: true
      can :summary, Legislation::Process,
          id: Legislation::Process.past.published.where(result_publication_enabled: true).ids
      can [:read, :changes, :go_to_version], Legislation::DraftVersion
      can [:read], Legislation::Question
      can [:read, :map, :share], Legislation::Proposal
      can [:search, :comments, :read, :create, :new_comment], Legislation::Annotation
      can [:read], ProjektQuestion
      can [:read, :create], ProjektQuestionAnswer

      can [:read, :help], ::SDG::Goal
      can :read, ::SDG::Phase

      can [:read, :json_data], DeficiencyReport
    end
  end
end
