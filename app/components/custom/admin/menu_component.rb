require_dependency Rails.root.join("app", "components", "admin", "menu_component").to_s

class Admin::MenuComponent < ApplicationComponent
  include LinkListHelper

  private

    def booths?
      %w[officers booths shifts booth_assignments officer_assignments].include?(controller_name) && controller.class.parent == Admin::Poll ||
        controller_name == "polls" && action_name == "booth_assignments"
    end

    def officers_link
      [
        t("admin.menu.poll_officers"),
        admin_officers_path,
        %w[officers officer_assignments].include?(controller_name)
      ]
    end

    def deficiency_reports?
      ( %w[officers categories statuses settings].include?(controller_name) && controller.class.parent == Admin::DeficiencyReports )
    end

    def deficiency_reports_list
      [
        t("custom.admin.menu.deficiency_reports.list"),
        admin_deficiency_reports_path,
        controller_name == "deficiency_reports"
      ]
    end

    def deficiency_report_officers
      [
        t("custom.admin.menu.deficiency_reports.officers"),
        admin_deficiency_report_officers_path,
        controller_name == "officers" && controller.class.parent == Admin::DeficiencyReports
      ]
    end

    def deficiency_report_categories
      [
        t("custom.admin.menu.deficiency_reports.categories"),
        admin_deficiency_report_categories_path,
        controller_name == "categories" && controller.class.parent == Admin::DeficiencyReports
      ]
    end

    def deficiency_report_statuses
      [
        t("custom.admin.menu.deficiency_reports.statuses"),
        admin_deficiency_report_statuses_path,
        controller_name == "statuses" && controller.class.parent == Admin::DeficiencyReports
      ]
    end

    def deficiency_report_settings
      [
        t("custom.admin.menu.deficiency_reports.settings"),
        admin_deficiency_report_settings_path,
        controller_name == "settings" && controller.class.parent == Admin::DeficiencyReports
      ]
    end

    def projekt_managers_link
      [
        t("custom.admin.menu.projekt_managers"),
        admin_projekt_managers_path,
        controller_name == "projekt_managers"
      ]
    end

    def profiles?
      %w[administrators projekt_managers organizations officials moderators valuators managers users].include?(controller_name)
    end

    def settings?
      controllers_names = ["settings", "tags", "geozones", "images", "content_blocks",
                           "local_census_records", "imports", "age_restrictions", "individual_groups", "individual_group_values"]
      controllers_names.include?(controller_name) &&
        controller.class.parent != Admin::Poll::Questions::Answers &&
        controller.class != Admin::DeficiencyReports::SettingsController
    end

    def settings_link
      [
        t("admin.menu.settings"),
        admin_settings_path,
        controller_name == "settings" &&
          controller.class != Admin::DeficiencyReports::SettingsController
      ]
    end

    def age_restrictions_link
      [
        t("custom.admin.menu.age_restrictions"),
        admin_age_restrictions_path,
        controller_name == "age_restrictions"
      ]
    end

    def customization?
      ["pages", "banners", "modal_notifications", "information_texts", "documents"].include?(controller_name) ||
        homepage? || pages?
    end

    def modal_notifications_link
      [
        t("custom.admin.menu.modal_notification"),
        admin_modal_notifications_path,
        controller_name == "modal_notifications"
      ]
    end

    def registered_addresses?
      %w[registered_addresses registered_address_groupings registered_address_streets].include?(controller_name)
    end

    def registered_addresses_list
      [
        t("custom.admin.menu.registered_addresses.list"),
        admin_registered_addresses_path,
        controller_name == "registered_addresses"
      ]
    end

    def registered_address_groupings_list
      [
        t("custom.admin.menu.registered_address_groupings.list"),
        admin_registered_address_groupings_path,
        controller_name == "registered_address_groupings"
      ]
    end

    def registered_address_streets_list
      [
        t("custom.admin.menu.registered_address_streets.list"),
        admin_registered_address_streets_path,
        controller_name == "registered_address_streets"
      ]
    end

    def individual_groups_link
      [
        t("custom.admin.menu.individual_groups"),
        admin_individual_groups_path,
        ["individual_groups", "individual_group_values"].include?(controller_name)
      ]
    end
end
