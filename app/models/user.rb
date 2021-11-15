class User < ApplicationRecord
  # Adds methods to set and authenticate against a Bcrypt password.
  # More info on: https://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
  has_secure_password
  has_one :airline, dependent: :destroy
  has_many :miles_offers, dependent: :destroy
  has_many :ticket_purchases, dependent: :destroy

  # This model is not part of the application
  # It is used to perform fake payments
  has_one :bank_account, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  after_create :create_airline, if: :is_airline?
  after_create :create_bank_account, unless: :is_support?

  TYPES = [:'Usuário', :'Companhia Aérea', :'Suporte']

  # The user type is stored as integer on the db. It can be 0, 1 or 2.
  # This method maps the number to a more meaningful symbol
  # Obs: Symbol is a string stored uniquely in the memory, unlike normal strings that are stored multiple times
  #
  # @return [Symbol]
  def type
    TYPES[user_type]
  end

  # Checks wether the user_type is 'Companhia Aérea'
  # 
  # @return [Boolean]
  def is_airline?
    type == :'Companhia Aérea'
  end

  # Checks wether the user_type is 'Suporte'
  # 
  # @return [Boolean]
  def is_support?
    type == :'Suporte'
  end

  # Creates an airline with parameters based on the user, and associates it with him
  # 
  # @return [Boolean] to inform the success (or not) of the creation
  def create_airline
    airline_params = {
      name: name,
      cnpj: cpf_cnpj,
      user: self
    }
    Airline.create(airline_params)
  end

  # Creates a bank account with random values and associates it with the user
  # 
  # @return [Boolean] to inform the success (or not) of the creation
  def create_bank_account
    BankAccount.create(user: self, credit_card_number: rand(1111..9999), balance: rand(100.0..50000.0))
  end

  # Removes the informed value from the user's bank account balance
  # 
  # @param [Float] value
  # @return [Boolean] to inform the success (or not) of the update
  def pay(value)
    self.bank_account.update(balance: bank_account.balance - value)
  end

  # Adds the informed value to the user's bank account balance
  # 
  # @param [Float] value
  # @return [Boolean] to inform the success (or not) of the update
  def refund(value)
    self.bank_account.update(balance: bank_account.balance + value)
  end
  # This method adds 'receive' as a synonym for the 'refund' method
  alias_method :receive, :refund

  # Validates if a payment can be done, and performs it if can.
  # If use_miles is true, checks if the user's current miles are enough to pay. If yes, subtracts
  # the due amount and returns true
  # If use_miles is false, checks if the user's bank account balance is enough to pay. If yes, subtracts
  # the due amount and returns true.
  # On either case, if the payment cannot be made returns false (and won't change any value)
  # 
  # @param [Float] payment
  # @param optional [Boolean] use_miles
  # @return [Boolean] to inform wether the payment was validated and made
  def validate_payment(payment, use_miles: false)
    if use_miles
      if miles * Site.first.mile_price >= payment
        miles_to_subtract = (payment / Site.first.mile_price).to_i
        self.update(miles: miles - miles_to_subtract)
        return true
      else
        return false
      end
    elsif self.bank_account.balance >= payment
      pay(payment)
      return true
    else
      return false
    end
  end

  # Uses the fake CreditCard::Miles API to check if the miles code informed is valid.
  # If it is, updates the user's miles with the due amount, invalidates the code on the API and
  # returns the quantity associated with the code.
  # If not, returns -1.
  # 
  # @param [String] code
  # @return [Integer] qty >= 0 if valid, -1 if not valid
  def redeem_miles(code)
    if CreditCard::Miles.valid_code?(code)
      qty = CreditCard::Miles.get_quantity(code)
      self.update(miles: miles + qty)
      CreditCard::Miles.redeem_code(code)
      qty
    else
      -1
    end
  end

end
