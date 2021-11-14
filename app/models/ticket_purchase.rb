class TicketPurchase < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  belongs_to :airline

  default_scope { where(cancelled_at: nil) }
end
