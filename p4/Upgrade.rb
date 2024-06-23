class Upgrade 
    include GameElement
    attr_reader :name, :points

    #constructor for upgrade
    def initialize(name, points)
        @name = name
        @points = points
    end

    #to string method
    def to_s
        "#{@name} (#{@points})"
    end
end