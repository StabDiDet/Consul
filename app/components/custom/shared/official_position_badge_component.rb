class Shared::OfficialPositionBadgeComponent < ApplicationComponent
  attr_reader :user

  def initialize(user:)
    @user = user
  end
end
