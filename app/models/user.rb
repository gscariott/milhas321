class User < ApplicationRecord
  has_secure_password
  has_one :airline, dependent: :destroy

  validates :miles, numericality: { greater_than_or_equal_to: 0 } 
  validates :email, presence: true, uniqueness: true

  after_create :create_airline, if: :is_airline?

  TYPES = [:'Usuário', :'Companhia Aérea', :'Suporte']

  def type
    TYPES[user_type]
  end

  def is_airline?
    type == :'Companhia Aérea'
  end

  def create_airline
    airline_params = {
      name: name,
      cnpj: cpf_cnpj,
      user: self
    }
    Airline.create(airline_params)
  end

  def redeem_miles(code)
    if CreditCard::Miles.valid_code?(code)
      qty = CreditCard::Miles.get_quantity(code)
      self.update(miles: miles + qty)
      CreditCard::Miles.redeem_code(code)
      qty
    else
      false
    end
  end

end
