class Operation < ApplicationRecord
  belongs_to :group

  belongs_to :author, class_name: "User"

  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user

  accepts_nested_attributes_for :participations,
                                allow_destroy: true,
                                reject_if: proc { |att| att['amount_share'].to_f <= 0 && att['id'].blank? }

  def participations_attributes=(attributes)
    attributes.each_value do |attribute|
      if attribute['id'].present? && attribute['amount_share'].to_f <= 0
        attribute['_destroy'] = true
      end
    end
    super
  end
end
