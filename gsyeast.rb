#!/usr/local/bin/ruby
require "rubygems"
require "google_spreadsheet"
require 'cinch'

class GSYeast
  include Cinch::Plugin

  match /yeast (.+)/

    def reloadData()
    if @ws == nil
      puts "first load of worksheet"
      @ws = @session.spreadsheet_by_key(@key).worksheets[0]
    else
      puts "reloading worksheet"
      @ws.reload()
    end
    buildIndex()
  end

  def buildIndex()
    @index={}
    for row in 1..@ws.num_rows
      @index[@ws[row, 1]]=row         
    end
  end

  def getRow(yeast)
    if @index[yeast]
      return @index[yeast]
    else
      return nil
    end
  end

  def initialize(*args)
    super
    # these are the current columns we are using - in order
    # MFG#,lab,product name, species, brewery source, temp range, attenuation range, flocculation, alcohol tolerance, pitching/ferm notes, notes, styles, same as, available, citation
    
    @key="0AmRc5_x3ehAfdFhBQ3pmczhqdHUtbmFONUYyZzVEY0E"
    @user="hbtbrewbot@gmail.com"
    @pass="gfx10101"
    @session=nil
    @ws=nil
    @index={}
    @session = GoogleSpreadsheet.login(@user,@pass)
    reloadData()
  end

  def getYeast(yeast)
    row=getRow(yeast)
    data=""
    for col in 1..@ws.num_cols
          data="#{data} "+@ws[row, col]
    end
    return data
  end

  def execute(m,yeast)
    yeast,cmd = yeast.split(' ')
    yeast.upcase!
    puts "got #{yeast} -  #{cmd}"
    puts @index
    if yeast=="RELOAD"
      reloadData()
    elsif getRow(yeast) != nil
      m.reply "#{m.user.nick}, #{yeast}: #{getYeast(yeast)}"
    else
      m.reply "#{m.user.nick}, you be crazy fool. #{yeast} doesn't exist!"
    end
  end
end
