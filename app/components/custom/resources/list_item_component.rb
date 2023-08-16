# frozen_string_literal: true

class Resources::ListItemComponent < ApplicationComponent
  renders_one :header
  renders_one :image_overlay_item
  renders_many :additional_body_sections
  renders_many :footer_sections

  DATE_FORMAT = "%d.%m.%Y".freeze

  def initialize(
    resource: nil,
    projekt: nil,
    title:,
    description:,
    image_url: nil,
    author: nil,
    subline: nil,
    url: nil,
    tags: [],
    image_placeholder_icon_class: "fa-file",
    header_style: nil
  )
    @resource = resource
    @title = title
    @projekt = projekt
    @description = description
    @image_url = image_url
    @author = author
    @url = url
    @subline = subline
    @tags = tags
    @resource_name = @resource.class.name.downcase.gsub("::", "_")
    @image_placeholder_icon_class = image_placeholder_icon_class
    @header_style = header_style
  end

  def component_class_name
    class_name = "#{@resource_name&.underscore}-list-item"

    if @wide
      class_name += " -wide"
    end

    class_name
  end

  def days_left
    if @end_date.present?
      "Noch #{(@end_date - Date.today).to_i} Tage"
    end
  end

  def date
    @date&.strftime(DATE_FORMAT)
  end

  def truncate_length
    if @wide
      150
    else
      120
    end
  end
end
