# Unit is a sub class of game element
require_relative 'GameElement'
class Unit
    include GameElement
    attr_accessor  :quality, :defence, :name, :points, :upgrades

    #Constructor for the class
    def initialize(name, points)
        @name = name
        @points = points
        @quality = 2
        @defence = 2
        @upgrades = []
    end
    #method to add upgrades to the Unit's upgrade field
    def addUpgrade(upgrade)
        @upgrades << upgrade
    end
    #method to remove an upgrrade from Unit
    def removeUpgrade(upgrade)
        @upgrades.delete(upgrade)
    end
    # getter method to points field
    def getPoints
        total = @points
        @upgrades.each{ |upgrade| total += upgrade.points}
        total
    end
    # getter method for upgrades field
    def getUpgrades()
        @upgrades
    end

    def to_s
        upgrade_string = @upgrades.map(&:to_s).join(', ')
        "#{@name} (#{getPoints}, #{@quality}, #{@defence})#{' upgrades: [' + upgrade_string + ']' unless upgrade_string.empty?}"
    end
end