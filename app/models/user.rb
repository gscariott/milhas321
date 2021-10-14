class User < ApplicationRecord
  has_secure_password
  has_one :airline, dependent: :destroy

  after_create :create_airline, if: :is_airline?

  TYPES = [:'Usuário', :'Companhia Aérea', :'Suporte']

  def type
    TYPES[user_type]
  end

  def is_airline?
    type == :'Companhia Aérea'
  end

  validates :email, presence: true, uniqueness: true
end
