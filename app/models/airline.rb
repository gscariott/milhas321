class Airline < ApplicationRecord
  belongs_to :user
  has_many :tickets, dependent: :destroy
  has_many :ticket_purchases
end
