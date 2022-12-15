require_dependency Rails.root.join("app", "components", "budgets", "ballot", "investment_component").to_s

class Budgets::Ballot::InvestmentComponent < ApplicationComponent
  delegate :current_user, to: :helpers

  private

    def delete_path
      budget_ballot_line_path(id: investment.id, budget_id: investment.budget.id)
    end

    def ballot
      Budget::Ballot.where(user: current_user, budget: budget).first_or_create!
    end

    def show_delete_vote_button?
      permission_problem = investment.reason_for_not_being_ballotable_by(current_user, ballot)

      permission_problem.blank? || permission_problem == :not_enough_available_votes
    end
end
