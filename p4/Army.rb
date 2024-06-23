class Army < Squad
    attr_accessor :player, :faction

    #constructor for Army
    def initialize(name, player, faction)
        #initialize like squad and add the player and faction field for the army
        super(name)
        @player = player
        @faction = faction
    end

    #out put player, faction, army, points, quality, defence and any units in the army
    def to_s
        "Player: #{@player},  faction: #{@faction}, army: #{name} (#{getPoints}, #{quality}, #{defence})#{' units: ' + units.map(&:to_s).join(' ') unless units.empty?}"
    end
end