class User < ApplicationRecord
  has_many :memberships
  has_many :groups, through: :memberships

  has_many :participations
  has_many :participating_operations, through: :participations, source: :operation

  has_many :authored_operations, class_name: "Operation", foreign_key: "author_id"

  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :username, presence: true
end
