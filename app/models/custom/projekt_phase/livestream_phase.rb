class ProjektPhase::LivestreamPhase < ProjektPhase
  has_many :projekt_livestreams, foreign_key: :projekt_phase_id,
    dependent: :destroy, inverse_of: :projekt_phase
  has_many :questions, -> { order(:id) }, foreign_key: :projekt_phase_id, class_name: "ProjektQuestion",
    inverse_of: :projekt_phase, dependent: :destroy

  def phase_activated?
    active?
  end

  def name
    "livestream_phase"
  end

  def resources_name
    "projekt_livestreams"
  end

  def default_order
    2
  end

  def resource_count
    projekt_livestreams.count
  end

  def question_list_enabled?
    projekt_settings
      .find_by(key: "projekt_feature.questions.show_questions_list")
      .value
      .present?
  end

  private

    def phase_specific_permission_problems(user, location)
      return :organization if user.organization?
    end
end
