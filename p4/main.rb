# include other needed files
require_relative 'GameElement'
require_relative 'Unit'
require_relative 'EnhancedUnit'
require_relative 'Hero'
require_relative 'Monster'
require_relative 'Squad'
require_relative 'Army'
require_relative 'Upgrade'

def process_input(input_file, output_file)
  # Initialize variables
  army = nil
  squad = nil
  enhanced_unit = nil
  unit = nil
  upgrade = nil

  # Open the output file for writing
  File.open(output_file, 'w') do |output|
    # Read the input file line by line
    File.readlines(input_file).each do |line|
      # Split the line into tokens using tab as the delimiter
      tokens = line.strip.split("\t")
      
      # Skip empty lines or lines with no tokens
      next if tokens.empty? || tokens[0].nil?

      # Process the tokens based on the first token
      case tokens[0].downcase
      when 'army:'
        # Create a new Army object
        army = Army.new(tokens[1], tokens[2], tokens[3])
        output.puts "Creating Army: #{tokens[1]}, #{tokens[2]}, #{tokens[3]}"
        output.puts "\t#{army} "
      when 'squad:'
        # Create a new Squad object
        squad = Squad.new(tokens[1])
        output.puts "Creating Squad: #{tokens[1]}"
        output.puts "\t#{squad} "
        output.puts "Adding Squad to Army" if army
        army.addUnit(squad) if army
        output.puts "\t#{army} " if army
      when 'hero:', 'monster:', 'unit:', 'enhanced unit:'
        # Create the corresponding unit object
        case tokens[0].downcase
        when 'hero:'
          unit = Hero.new(tokens[1], tokens[2].to_i)
          enhanced_unit = unit
          tokens[0] = 'Hero'
        when 'monster:'
          unit = Monster.new(tokens[1], tokens[2].to_i)
          enhanced_unit = unit
          tokens[0] = 'Monster'
        when 'unit:'
          unit = Unit.new(tokens[1], tokens[2].to_i)
          tokens[0] = 'Unit'
        when 'enhanced unit:'
          unit = EnhancedUnit.new(tokens[1], tokens[2].to_i)
          unit.specialrule = tokens[3]
          enhanced_unit = unit
          tokens[0] = 'Enhanced Unit'
        end
        
        output.puts "Creating #{tokens[0]}: #{tokens[1]}, #{tokens[2]}"
        output.puts "\t#{unit}"
        
        # Add the unit to the Squad only if a Squad exists
        if squad
          output.puts "Adding #{tokens[0]} to Squad"
          squad.addUnit(unit)
          output.puts "\t#{squad} "
        end
      when 'special rule:'
        # Add a special rule to the last created enhanced unit
        if enhanced_unit
          output.puts "Adding special rule #{tokens[1]} to #{enhanced_unit}"
          enhanced_unit.specialrule = tokens[1]
          output.puts "Added special rule #{tokens[1]} to #{enhanced_unit}"
        end
      when 'upgrade:'
        # Create a new Upgrade object
        upgrade = Upgrade.new(tokens[1], tokens[2].to_i)
        output.puts "Creating Upgrade: #{tokens[1]}, #{tokens[2]}"
        output.puts "\t#{upgrade}"
        
        # Add the upgrade to the last created unit
        if unit
          output.puts "Adding Upgrade to Unit"
          unit.addUpgrade(upgrade)
          output.puts "\t#{unit}"
        end
      end
    end

    # Output the summary of final units
    output.puts "Summary of final units"
    output.puts "Last army: #{army} "
    output.puts "Last squad: #{squad} "
    output.puts "Last enhanced unit: #{enhanced_unit}"
    output.puts "Last unit: #{unit}"
  end
end

# Get input and output file from command line args
input_file = ARGV[0]
output_file = ARGV[1]

# Process the input file and write to the output file
process_input(input_file, output_file)