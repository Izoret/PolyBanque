class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  has_many :operations, dependent: :destroy

  def total_expenses
    operations.sum :total_amount
  end

  def total_expenses_of(user)
    operations.where(author: user).sum :total_amount
  end
end
