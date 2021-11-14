class User < ApplicationRecord
  has_secure_password
  has_one :airline, dependent: :destroy
  has_many :miles_offers, dependent: :destroy

  # This model is not part of the application
  # It is used to perform fake payments
  has_one :bank_account, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  after_create :create_airline, if: :is_airline?
  after_create :create_bank_account, unless: :is_support?

  TYPES = [:'Usuário', :'Companhia Aérea', :'Suporte']

  def type
    TYPES[user_type]
  end

  def is_airline?
    type == :'Companhia Aérea'
  end

  def is_support?
    type == :'Suporte'
  end

  def create_airline
    airline_params = {
      name: name,
      cnpj: cpf_cnpj,
      user: self
    }
    Airline.create(airline_params)
  end

  def create_bank_account
    BankAccount.create(user: self, credit_card_number: rand(1111..9999), balance: rand(100.0..50000.0))
  end

  def pay(value)
    self.bank_account.update(balance: bank_account.balance - value)
  end

  def refund(value)
    self.bank_account.update(balance: bank_account.balance + value)
  end
  alias_method :receive, :refund

  def validate_payment(payment)
    if self.bank_account.balance >= payment
      pay(payment)
      return true
    else
      return false
    end
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
