require_dependency Rails.root.join("app", "helpers", "map_locations_helper").to_s

module MapLocationsHelper
    def render_map(map_location, parent_class, editable, remove_marker_label, investments_coordinates = [])
      map_location = MapLocation.new if map_location.nil?
      map = content_tag :div, "",
                        id: "#{dom_id(map_location)}_#{parent_class}",
                        class: "map_location map",
                        data: prepare_map_settings(map_location, editable, parent_class, investments_coordinates)
      map += map_location_remove_marker(map_location, remove_marker_label) if editable
      map
    end

    private

      def prepare_map_settings(map_location, editable, parent_class, process_coordinates = nil)
        options = {
        parent_class: parent_class,
          map: "",
          map_center_latitude: map_location_latitude(map_location),
          map_center_longitude: map_location_longitude(map_location),
          map_zoom: map_location_zoom(map_location),
          map_tiles_provider: Rails.application.secrets.map_tiles_provider,
          map_tiles_provider_attribution: Rails.application.secrets.map_tiles_provider_attribution,
          marker_editable: editable,
          marker_remove_selector: "##{map_location_remove_marker_link_id(map_location)}",
          latitude_input_selector: "##{map_location_input_id(parent_class, "latitude")}",
          longitude_input_selector: "##{map_location_input_id(parent_class, "longitude")}",
          zoom_input_selector: "##{map_location_input_id(parent_class, "zoom")}",
          marker_process_coordinates: process_coordinates
        }
        options[:marker_latitude] = map_location.latitude if map_location.latitude.present?
        options[:marker_longitude] = map_location.longitude if map_location.longitude.present?
        options
      end
  end
