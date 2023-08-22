class FormularField < ApplicationRecord
  KINDS = %w[string email date dropdown].freeze

  belongs_to :formular
  after_create :set_key, :set_options

  validates :name, presence: true, uniqueness: { scope: :formular_id }
  validates :kind, presence: true, inclusion: { in: KINDS }

  default_scope { order(:given_order, :id) }

  def self.order_formular_fields(ordered_array)
    ordered_array.each_with_index do |formular_field_id, order|
      find(formular_field_id).update_column(:given_order, (order + 1))
    end
  end

  private

    def set_key
      update!(key: "#{name.parameterize.underscore}_#{id}")
    end

    def set_options
      update!(options: send("#{kind}_field_options")) if kind.in?(["string", "email"])
    end

    def string_field_options
      {
        validates: {
          length: { minimum: 2, maximum: 255 }
        }
      }
    end

    def email_field_options
      {
        validates: {
          format: URI::MailTo::EMAIL_REGEXP.to_s
        }
      }
    end
end
