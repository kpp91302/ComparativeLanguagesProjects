class Hero < EnhancedUnit
    #initialize Hero
    def initialize(name, points)
        #same as Enhanced unit but we update quality and defence to be better
        super(name, points)
        @quality = 5
        @defence = 5
    end
end