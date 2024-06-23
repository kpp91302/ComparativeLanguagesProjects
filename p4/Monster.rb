class Monster < EnhancedUnit
    #constructor for Monster
    def initialize(name, points)
        #same as enhanced unit but with higher defence and quality stat
        super(name, points)
        @defence = 4
        @quality = 4
    end
end