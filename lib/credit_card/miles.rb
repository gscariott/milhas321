require 'csv'

module CreditCard
  class Miles

    def self.valid_code?(code)
      generated_codes.include?(code) && !redeemed_codes.include?(code)
    end

    def self.redeem_code(code)
      if valid_code?(code)
        CSV.open("lib/credit_card/redeemed_codes.csv", "a") do |csv|
          csv << [code, get_quantity(code)]
        end
        true
      else
        false
      end
    end

    def self.get_quantity(code)
      index = generated_codes.index(code)

      generated_miles[index][1].to_i
    end

    def self.redeemed_codes
      codes = []
      CSV.foreach("lib/credit_card/redeemed_codes.csv") do |row|
        codes << row[0]
      end

      codes
    end

    def self.generated_codes
      codes = []
      CSV.foreach("lib/credit_card/generated_codes.csv") do |row|
        codes << row[0]
      end

      codes
    end

    def self.generated_miles
      codes = []
      CSV.foreach("lib/credit_card/generated_codes.csv") do |row|
        codes << row
      end

      codes
    end

  end
end