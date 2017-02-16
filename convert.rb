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
  end

  def execute(m,convert)

    units = convert.split(' to ')

    re = /(^-?\d+(:?\.\d+)?)\s*([CFK])/
    match = units[0].match re
    puts match
    if (match)
      last = match.captures.length
      temp = match.captures[0]
      temp_unit = match.captures[last-1]

      units[0] = "#{temp} temp#{temp_unit}"
      units[1] = "temp#{units[1]}"
    end

    unit0 = Unit.new(units[0])
    if unit0.compatible?(units[1])
      unit1 = unit0 >> units[1]

      m.reply "#{m.user.nick}, #{unit0} is #{unit1.to_s('%0.2f')}"
    end
  end
end
