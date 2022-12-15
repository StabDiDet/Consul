class ProjektPhase::ProjektNotificationPhase < ProjektPhase
  def phase_activated?
    active?
  end

  def name
    "projekt_notification_phase"
  end

  def resources_name
    "projekt_notifications"
  end

  private

    def phase_specific_permission_problems(user, location)
      return :organization if user.organization?
    end
end
