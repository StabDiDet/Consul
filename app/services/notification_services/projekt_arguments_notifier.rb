module NotificationServices
  class ProjektArgumentsNotifier < ApplicationService
    def initialize(projekt_phase_id)
      @projekt_phase = ProjektPhase.find(projekt_phase_id)
    end

    def call
      users_to_notify_ids.each do |user_id|
        NotificationServiceMailer.projekt_arguments(user_id, @projekt_phase.id).deliver_later
      end
    end

    private

      def users_to_notify_ids
        [projekt_phase_subscriber_ids].flatten.uniq
      end

      def projekt_phase_subscriber_ids
        return [] unless @projekt_phase.projekt_arguments.any?

        @projekt_phase.subscribers.ids
      end
  end
end
