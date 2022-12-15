require_dependency Rails.root.join("app", "controllers", "admin", "users_controller").to_s

class Admin::UsersController < Admin::BaseController
  def verify
    @user = User.find(params[:id])
    @user.take_votes_from_erased_user
    geozone = Geozone.find_with_plz(@user.plz)
    @user.update!(verified_at: Time.current, geozone: geozone)

    Mailer.manual_verification_confirmation(@user).deliver_later
  end

  def unverify
    @user = User.find(params[:id])
    @user.take_votes_from_erased_user
    @user.update!(verified_at: nil, geozone: nil)
  end
end
