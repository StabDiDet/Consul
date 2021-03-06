class Sidebar::ProjektsFilterComponent < ApplicationComponent
  delegate :projekt_filter_resources_name, :show_archived_projekts_in_sidebar?, to: :helpers

  def initialize(top_level_active_projekts, top_level_archived_projekts, all_resources, current_tab_phase = nil, current_projekt = nil)
    @top_level_active_projekts = top_level_active_projekts
    @top_level_archived_projekts = top_level_archived_projekts
    @all_resources = all_resources
    @current_projekt = current_projekt
    @current_tab_phase = current_tab_phase
  end

	private

  def show_filter?
    @top_level_active_projekts.count > 1 ||
      ( @top_level_active_projekts.count == 1 && @top_level_active_projekts.first.children.with_order_number.selectable_in_sidebar_current(resources_name).any? ) ||
      @top_level_archived_projekts.count > 1 ||
      ( @top_level_archived_projekts.count == 1 &&  @top_level_archived_projekts.first.children.with_order_number.selectable_in_sidebar_expired(resources_name).any? )
  end

  def show_archived_projekts_in_sidebar?
    true
	end

  def resources_name
    projekt_filter_resources_name
	end

  def resource_name_js
    if @current_tab_phase && @current_projekt
      "footer#{@current_projekt.id}#{@current_tab_phase.name.capitalize}"
    else
      controller_name
    end
  end

  def projekts_to_toggle_js
    if @current_projekt
      @current_projekt.all_children_ids.unshift(@current_projekt.id).unshift(@current_projekt.all_parent_ids).join(',')
    else
      ''
    end
  end

  def form_path
    if params[:current_tab_path]
      url_for(action: params[:current_tab_path], controller: 'pages')
    else
      url_for(action: 'index', controller: controller_name)
    end
  end

  def local_form?
    controller_name == 'pages' ? false : true
  end

  def cache_key
    [
      Projekt.all,
      ProjektSetting.where('key LIKE ?', 'projekt_feature.main.activate'),
      ProjektSetting.where('key LIKE ?', '%show_in_sidebar_filter%'),
      params[:filter_projekt_ids],
      controller_name,
      action_name
    ].flatten
  end
end
