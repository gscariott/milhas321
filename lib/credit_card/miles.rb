require 'csv'

module CreditCard

  # This class provides a fake API to redeem miles codes
  # It persists generated and redeemed codes on CSV files with the pattern code,quantity
  class Miles

    # Checks wether the code is valid, i.e., was generated and not redeemed yet
    # 
    # @param [string] code
    # @return [Boolean]
    def self.valid_code?(code)
      generated_codes.include?(code) && !redeemed_codes.include?(code)
    end

    # If the informed code is valid, adds the array [code, qty] to the file of redeemed codes and
    # returns true. If not, returns false
    # 
    # @param [string] code
    # @return [Boolean] wether the code was redeemed or not
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

    # Returns the quantity associated with the code informed
    # 
    # @param [string] code
    # @return [Integer] quantity
    def self.get_quantity(code)
      index = generated_codes.index(code)

      generated_miles[index][1].to_i
    end

    # Returns an array with all the redeemed codes
    # 
    # @return [Array[String]]
    def self.redeemed_codes
      codes = []
      CSV.foreach("lib/credit_card/redeemed_codes.csv") do |row|
        codes << row[0]
      end

      codes
    end

    # Returns an array with all the generated codes
    # 
    # @return [Array[String]]
    def self.generated_codes
      codes = []
      CSV.foreach("lib/credit_card/generated_codes.csv") do |row|
        codes << row[0]
      end

      codes
    end

    # Returns an array with all the generated codes and quantity
    # 
    # @return [Array[Array[String, String]]]
    def self.generated_miles
      codes = []
      CSV.foreach("lib/credit_card/generated_codes.csv") do |row|
        codes << row
      end

      codes
    end

  end
end