require "rails_helper"

describe "Valuation" do
  let(:user) { create(:user) }

  context "Access" do
    xscenario "Access as regular user is not authorized" do
      login_as(user)
      visit root_path

      expect(page).not_to have_link("Menu")
      expect(page).not_to have_link("Valuation")

      visit valuation_root_path

      expect(page).not_to have_current_path(valuation_root_path)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content "You do not have permission to access this page"
    end

    xscenario "Access as moderator is not authorized" do
      create(:moderator, user: user)
      login_as(user)

      visit root_path
      click_link "Menu"

      expect(page).not_to have_link("Valuation")

      visit valuation_root_path

      expect(page).not_to have_current_path(valuation_root_path)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content "You do not have permission to access this page"
    end

    xscenario "Access as manager is not authorized" do
      create(:manager, user: user)
      login_as(user)

      visit root_path
      click_link "Menu"

      expect(page).not_to have_link("Valuation")

      visit valuation_root_path

      expect(page).not_to have_current_path(valuation_root_path)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content "You do not have permission to access this page"
    end

    xscenario "Access as SDG manager is not authorized" do
      create(:sdg_manager, user: user)
      login_as(user)

      visit root_path
      click_link "Menu"

      expect(page).not_to have_link("Valuation")

      visit valuation_root_path

      expect(page).not_to have_current_path(valuation_root_path)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content "You do not have permission to access this page"
    end

    xscenario "Access as poll officer is not authorized" do
      create(:poll_officer, user: user)
      login_as(user)

      visit root_path
      click_link "Menu"

      expect(page).not_to have_link("Valuation")

      visit valuation_root_path

      expect(page).not_to have_current_path(valuation_root_path)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content "You do not have permission to access this page"
    end

    xscenario "Access as a valuator is authorized" do
      create(:valuator, user: user)
      create(:budget)
      login_as(user)

      visit root_path
      click_link "Menu"
      click_link "Valuation"

      expect(page).to have_current_path(valuation_root_path)
      expect(page).not_to have_content "You do not have permission to access this page"
    end

    xscenario "Access as an administrator is authorized" do
      create(:administrator, user: user)
      create(:budget)
      login_as(user)

      visit root_path
      click_link "Menu"
      click_link "Valuation"

      expect(page).to have_current_path(valuation_root_path)
      expect(page).not_to have_content "You do not have permission to access this page"
    end
  end

  xscenario "Valuation access links" do
    create(:valuator, user: user)
    create(:budget)
    login_as(user)

    visit root_path
    click_link "Menu"

    expect(page).to have_link("Valuation")
    expect(page).not_to have_link("Administration")
    expect(page).not_to have_link("Moderation")
  end

  xscenario "Valuation dashboard" do
    create(:valuator, user: user)
    create(:budget)

    login_as(user)
    visit root_path

    click_link "Menu"
    click_link "Valuation"

    expect(page).to have_current_path(valuation_root_path)
    expect(page).to have_css("#valuation_menu")
    expect(page).not_to have_css("#admin_menu")
    expect(page).not_to have_css("#moderation_menu")
  end
end
