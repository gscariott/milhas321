class Ticket < ApplicationRecord
  belongs_to :airline
  has_many :ticket_purchases, dependent: :destroy

  scope :sold, -> { where(sold: true) }
  scope :not_sold, -> { where(sold: false) }
end
