require_dependency Rails.root.join("app", "components", "debates", "votes_component").to_s

class Debates::VotesComponent < ApplicationComponent
  delegate :user_signed_in?, :link_to_signin, :link_to_signup,
           :link_to_verify_account, to: :helpers

  private

    def permission_problem_key
      @permission_problem_key ||= @projekt_phase.permission_problem(current_user)
    end

    def cannot_vote_text
      return nil if permission_problem_key.blank?

      if permission_problem_key == :not_logged_in
        t(path_to_key,
              sign_in: link_to_signin, sign_up: link_to_signup)

      else
        sanitize(t(path_to_key,
              verify: link_to_verify_account,
              city: Setting["org_name"],
              geozones: @projekt_phase.geozone_restrictions_formatted,
              age_restriction: @projekt_phase.age_restriction_formatted,
              restricted_streets: @projekt_phase.street_restrictions_formatted,
              individual_group_values: @projekt_phase.individual_group_value_restriction_formatted
        ), attributes: %w(class rel data-method href))

      end
    end

    def path_to_key
      if @projekt_phase &&
        I18n.exists?("custom.projekt_phases.permission_problem.votes_component.#{@projekt_phase.name}.#{permission_problem_key}")
        "custom.projekt_phases.permission_problem.votes_component.#{@projekt_phase.name}.#{permission_problem_key}"
      else
        "custom.projekt_phases.permission_problem.votes_component.shared.#{permission_problem_key}"
      end
    end
end
