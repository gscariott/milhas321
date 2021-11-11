module CreditCard
  class API
    attr_accessor :miles_list

    def initialize
      @miles_list = {
        m1: {qty: 10, available: true},
        m2: {qty: 25, available: false},
        m3: {qty: 50, available: true} 
      }
    end
    
    def self.is_code_valid?(code)
      if @miles_list[key].present?
        return @miles_list[key][:available]
      end

      return false
    end

    def self.get_qty(code)
      return @miles_list[key][:qty]
    end

    def self.invalidate_code(code)
      @miles_list[key][:available] = false
    end  
  end
end