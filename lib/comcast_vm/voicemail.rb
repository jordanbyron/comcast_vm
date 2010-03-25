module ComcastVm
  class Voicemail
    attr_reader :number
    
    def initialize(number)
      @number = number
    end
  end
end