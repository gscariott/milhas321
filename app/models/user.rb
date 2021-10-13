class User < ApplicationRecord
  has_secure_password

  TYPES = ['Usuário', 'Companhia Aérea', 'Suporte']

  def type
    TYPES[user_type]
  end

  validates :email, presence: true, uniqueness: true
end
