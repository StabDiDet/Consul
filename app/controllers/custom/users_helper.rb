require_dependency Rails.root.join("app", "helpers", "users_helper").to_s

module UsersHelper
  def proposal_limit_exceeded?(user)
    user.proposals.where(retired_at: nil).count >= Setting['extended_option.max_active_proposals_per_user'].to_i
  end

  def ck_editor_class(current_user)
   if extended_feature?("extended_editor_for_admins") && current_user.administrator?
     'extended'
   elsif extended_feature?("extended_editor_for_users")
     'extended'
   else
     'regular'
   end
  end
end
