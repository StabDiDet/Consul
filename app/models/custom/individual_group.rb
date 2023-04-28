class IndividualGroup < ApplicationRecord
  has_many :individual_group_values, dependent: :destroy
  validates :name, presence: true

  enum kind: { hard: 0, soft: 1 }
end
