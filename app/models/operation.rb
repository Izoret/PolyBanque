class Operation < ApplicationRecord
  belongs_to :group

  belongs_to :author, class_name: "User"

  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user
end
