#!/usr/local/bin/ruby
require 'cinch'
require 'ruby-units'

class Convert
  include Cinch::Plugin
  @help="!convert"
  match(/convert (.+)/)
  def execute(m,convert)
    
    units = convert.split(' to ')

    unit0 = Unit(units[0])
    if unit0.compatible?(units[1])
      unit1 = unit0 >> units[1]
      
      m.reply "#{m.user.nick}, #{unit0} is #{unit1.to_s('%0.2f')}"
    end
  end
end
