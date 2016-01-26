#!/usr/local/bin/ruby
require 'cinch'
require 'ruby-units'

class Convert
  include Cinch::Plugin
  @help="!convert"
  match(/convert (.+)/)
  
  def initialize(*args)
    super
    
    Unit.define("bbl") do |unit|
      unit.aliases = "barrel"
      unit.definition = Unit.new('31 gallons')
      unit.display_name = "bbl"
    end
    
    Unit.define("beers") do |unit|
      unit.aliases = %w{bottles beer-bottles}
      unit.definition = Unit.new('12 floz')
      unit.display_name = "beer-bottles"
    end
    
    Unit.redefine!("tempC") do |celsius|
      celsius.aliases = %w{tC tempC C}
    end
    
    Unit.redefine!("tempF") do |fahrenheit|
      fahrenheit.aliases = %w{tF tempF F}
    end
  end

  def execute(m,convert)
    
    units = convert.split(' to ')

    unit0 = Unit.new(units[0])
    if unit0.compatible?(units[1])
      unit1 = unit0 >> units[1]
      
      m.reply "#{m.user.nick}, #{unit0} is #{unit1.to_s('%0.2f')}"
    end
  end
end
