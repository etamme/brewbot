#!/usr/local/bin/ruby

require 'cinch'
require 'csv'

class Yeast
  include Cinch::Plugin

  match /yeast (.+)/

  @yeastData={}



  def reloadData()
    @yeastData={}
    CSV.foreach("./YeastBot.csv") do |row|
      @yeastData[row[0]]=row[1]+" - "+row[2]+", "+row[3]
    end
  end

  def initialize(*args)
    super
    reloadData()
  end

  def execute(m,yeast)
    if yeast.upcase=="RELOAD"
      reloadData()
    elsif @yeastData[yeast.upcase] != nil
      m.reply "#{m.user.nick}, #{yeast}: #{@yeastData[yeast.upcase]}"
    else
      m.reply "#{m.user.nick}, you be crazy fool. #{yeast} doesn't exist!"
    end
  end
end
