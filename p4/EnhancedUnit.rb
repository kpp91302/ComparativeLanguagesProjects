require_relative 'Unit'
require_relative 'GameElement'
class EnhancedUnit < Unit
    
    attr_accessor :specialrule

    #constructor for EnhancedUnit
    def initialize(name, points)
        #same as unit with addition of special rule
        super(name, points)
        @specialrule = nil
    end

    #output same as unit and addition of special rule if any are present
    def to_s
        "#{super}#{' special rule: [' + @specialrule + ']' if @specialrule}"
    end
end