class ProjektPhase < ApplicationRecord
  REGULAR_PROJEKT_PHASES = [
    "ProjektPhase::MilestonePhase",
    "ProjektPhase::ProjektNotificationPhase",
    "ProjektPhase::NewsfeedPhase",
    "ProjektPhase::EventPhase",
    "ProjektPhase::ArgumentPhase",
    "ProjektPhase::LivestreamPhase"
  ].freeze

  translates :phase_tab_name, touch: true
  translates :new_resource_button_name, touch: true
  translates :resource_form_title, touch: true
  include Globalizable

  belongs_to :projekt, optional: true, touch: true
  belongs_to :age_restriction
  has_many :projekt_phase_geozones, dependent: :destroy
  has_many :geozone_restrictions, through: :projekt_phase_geozones, source: :geozone,
           after_add: :touch_updated_at, after_remove: :touch_updated_at

  scope :regular_phases, -> { where.not(type: REGULAR_PROJEKT_PHASES) }
  scope :special_phases, -> { where(type: REGULAR_PROJEKT_PHASES) }

  scope :active, -> { where(active: true) }
  scope :current, ->(timestamp = Time.zone.today) {
    active
      .where("start_date IS NULL OR start_date <= ?", timestamp)
      .where("end_date IS NULL OR end_date >= ?", timestamp)
  }

  def selectable_by?(user)
    permission_problem(user).blank?
  end

  alias_method :votable_by?, :selectable_by?
  alias_method :comments_allowed?, :selectable_by?

  def not_active?
    !active?
  end

  def expired?
    end_date.present? && end_date < Time.zone.today
  end

  def current?
    phase_activated? &&
      ((start_date <= Time.zone.today if start_date.present?) || start_date.blank?) &&
      ((end_date >= Time.zone.today if end_date.present?) || end_date.blank?)
  end

  def not_current?
    !current?
  end

  def permission_problem(user, location: nil)
    return :not_logged_in unless user
    return :phase_not_active if not_active?
    return :phase_expired if expired?
    return :phase_not_current if not_current?
    return :not_verified if verification_restricted && !user.level_three_verified?

    if phase_specific_permission_problems(user, location).present?
      return phase_specific_permission_problems(user, location)
    end

    unless Setting["feature.user.skip_verification"].present?
      return age_permission_problem(user) if age_permission_problem(user).present?
      return geozone_permission_problem(user) if geozone_permission_problem(user)
    end

    nil
  end

  def geozone_allowed?(user)
    geozone_permission_problem(user).present?
  end

  def geozone_restrictions_formatted
    geozone_restrictions.map(&:name).flatten.join(", ")
  end

  def age_restriction_formatted
    age_restriction.present? ? age_restriction.name.downcase : ""
  end

  private

    def phase_specific_permission_problems(user)
      nil
    end

    def geozone_permission_problem(user)
      case geozone_restricted
      when "no_restriction" || nil
        nil
      when "only_citizens"
        if !user.level_three_verified?
          :not_verified
        elsif user.not_current_city_citizen?
          :only_citizens
        end
      when "only_geozones"
        if !user.level_three_verified?
          :not_verified
        elsif !geozone_restrictions.include?(user.geozone)
          :only_specific_geozones
        end
      end
    end

    def age_permission_problem(user)
      return nil if age_restriction.blank?
      return :not_verified if !user.level_three_verified?
      return nil if age_restriction.min_age <= user.age && user.age <= age_restriction.max_age

      :only_specific_ages
    end

    def touch_updated_at(geozone)
      touch if persisted?
    end
end
