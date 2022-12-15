require_dependency Rails.root.join("app", "components", "proposals", "new_component").to_s

class Proposals::NewComponent < ApplicationComponent

  def initialize(proposal, selected_projekt)
    @proposal = proposal
    @selected_projekt = selected_projekt
  end

  private

  def proposals_back_link_path
    if params[:origin] == 'projekt'
      projekt = Projekt.find(params[:projekt_id])
      page = projekt.page
      proposal_phase_id = projekt.proposal_phase.id

      link_to "/#{page.slug}?selected_phase_id=#{proposal_phase_id}", class: "back" do
        tag.span(class: "icon-angle-left") + t("shared.back")
      end

    else
      back_link_to proposals_path

    end
  end
end
