class Operation < ApplicationRecord
  belongs_to :group

  belongs_to :author, class_name: "User"

  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user

  validates :total_amount, numericality: { greater_than: 0 }
  validate :amount_must_match_participations_sum

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

  private def amount_must_match_participations_sum
    current_participations = participations.reject(&:marked_for_destruction?)

    sum = current_participations.sum { |p| p.amount_share || 0 }

    unless (total_amount - sum).abs <= 0.011
      errors.add(:base, "La somme des participations (#{sum}) doit être égale au montant total (#{total_amount})")
    end
  end
end
