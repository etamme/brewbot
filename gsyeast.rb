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
    @map={} 
    @map['MFG']=1
    @map['LAB']=2
    @map['PRODUCT']=3
    @map['SPECIES']=4
    @map['SOURCE']=5
    @map['TEMP']=6
    @map['ATTENUATION']=7
    @map['FLOCCULATION']=8
    @map['TOLERANCE']=9
    @map['PITCH_NOTES']=10
    @map['NOTES']=11
    @map['STYLES']=12
    @map['SAME_AS']=13
    @map['AVAIL']=14
    @map['CITE']=15

    @key="0AmRc5_x3ehAfdFhBQ3pmczhqdHUtbmFONUYyZzVEY0E"
    @user="foo@gmail.com"
    @pass="pass"
    @session=nil
    @ws=nil
    @index={}
    @session = GoogleSpreadsheet.login(@user,@pass)
    reloadData()
  end

  def getYeast(yeast,cmd)
    row=getRow(yeast)
    data=""
    # our default set of columns to return, along with their abbreviatted display elements.
    default={'PRODUCT'=>'','ATTENUATION'=>'att:', 'TOLERANCE'=>'tol:','TEMP'=>'temp:','FLOCCULATION'=>'flocc:','SOURCE'=>'src:','SAME_AS'=>'eqv:'}
    if cmd==nil
       # loop through each column and check that is has data.
       default.each do |k,v|
         if @ws[row,@map[k]] !=''
           if v !=""
             tag="#{v} "
           else
             tag=""
           end

           if data==""
             data="#{tag}#{@ws[row,@map[k]]}"
           else
            data="#{data} #{tag}#{@ws[row,@map[k]]}"
           end
         end
       end
    elsif cmd!='HELP'
      if @map[cmd]
        if @ws[row, @map[cmd]] != ""
          data="#{data} "+@ws[row, @map[cmd]]
        else
          data="no #{cmd.downcase} information"
        end
      else
        data="Unable to find matching command, please use !yeast #{yeast} help"
      end
    else
      data="!yeast MFG### [help|lab|product|species|source|temp|attenuation|flocculation|tolerance|pitch_notes|notes|styles|same_as|avail|cite]"
    end
    return data
  end

  def execute(m,yeast)
    yeast,cmd = yeast.split(' ')
    yeast.upcase!
    if cmd!=nil
      cmd.upcase!
    end
    puts "got #{yeast} -  #{cmd}"
    #puts @index
    if yeast=="RELOAD"
      reloadData()
    elsif getRow(yeast) != nil
      m.reply "#{m.user.nick}, #{yeast}: #{getYeast(yeast,cmd)}"
    else
      m.reply "#{m.user.nick}, you be crazy fool. #{yeast} doesn't exist!"
    end
  end
end
