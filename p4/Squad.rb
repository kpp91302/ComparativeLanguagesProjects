require_relative 'EnhancedUnit'
require_relative 'Unit'
class Squad < EnhancedUnit
    attr_accessor :units

    #constructor for Squad
    def initialize(name)
        #same as enhanced unit but we add an array to store all units belonging to the squad
        super(name, 0)
        @units = []
    end

    #add a unit to units array
    def addUnit(unit)
        @units << unit
    end

    #remove a unit from units array
    def removeUnit(unit)
        @units.delete(unit)
    end

    #get total points from each unit and sum it up
    def getPoints
        total_points = 0
        #use getPoints from unit class to get points from each unit
        @units.each { |unit| total_points += unit.getPoints }
        total_points
    end

    #to string method
    def to_s
        "#{name} (#{getPoints}, #{quality}, #{defence})#{' units: ' + units.map(&:to_s).join(' ') unless units.empty?}"
    end
end