class Budgets::Investments::CommentsFormComponent < ApplicationComponent
  delegate :current_user, :user_signed_in?, :link_to_verify_account, :link_to_signin, :link_to_signup, to: :helpers

  def initialize(investment)
    @investment = investment
  end

  private
    def reason
      @reason ||= @investment.permission_problem(current_user)
    end

    def commenting_allowed?
      reason.blank?
    end

    def cannot_comment_reason
      sanitize(t("custom.comments.restricted.#{reason}",
        signin: link_to_signin,
        signup: link_to_signup,
        verify_account: link_to_verify_account,
        city: Setting["org_name"],
        geozones: @investment.budget.projekt_phase.geozone_restrictions_formatted,
        age_restriction: @investment.budget.projekt_phase.age_restriction_formatted,
        restricted_streets: @investment.budget.projekt_phase.street_restrictions_formatted,
        individual_group_values: @investment.budget.projekt_phase.individual_group_value_restriction_formatted
       ), attributes: %w(class rel data-method href))
    end
end
