#!/usr/local/bin/ruby
require "rubygems"
require "google_drive"
require 'cinch'
require 'yaml'

class GDHops
  include Cinch::Plugin
  @help="!hops"
  match /hops (.+)/

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
      @index[@ws[row, 1].upcase]=row
    end
  end

  def getRow(hops)
    if @index[hops]
      return @index[hops]
    else
      return nil
    end
  end

  def initialize(*args)
    super
    # load config from yaml file
    @hops_config=[]
    File.open('gdrive.yaml','r').each do |object|
      @hops_config << YAML::load(object)
    end
    @user=@hops_config.first['user']
    @pass=@hops_config.first['pass']
    @key=@hops_config.first['hops_key']

    # these are the current columns we are using - in order
    # Name, origin, type, aroma, alpha acids (low), alpha acids (high), beta acids (low), beta acids (high), cohumulone (low), cohumulone (high), substitutes, notes
    @map={}
    @map['NAME']=1
    @map['ORIGIN']=2
    @map['TYPE']=3
    @map['AROMA']=4
    @map['AA_RANGE']=5
    @map['SUBS']=22
    @map['NOTES']=23

    @session=nil
    @ws=nil
    @index={}
    @session = GoogleDrive.login(@user,@pass)
    reloadData()
  end

  def getHops(hops,cmd)
    row=getRow(hops)
    data=""
    # our default set of columns to return, along with their abbreviatted display elements.
    default={'NAME'=>'','ORIGIN'=>'origin:','TYPE'=>'type:','AROMA'=>'aroma:','AA_RANGE'=>'AA:','SUBS'=>'subs:','NOTES'=>'notes:'}
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
        data="Unable to find matching command, please use !hops #{hops} help"
      end
    else
      data="!hops NAME [help|name|origin|type|aa range|subs|notes]"
    end
    return data
  end

  def execute(m,hops)
    if(m.bot.nick != "homebrewbot")
      if(m.bot.user_list.find("homebrewbot"))
        return 0
      else
        m.bot.nick="homebrewbot"
      end
    end

    hops,cmd = hops.split(' ')
    hops.upcase!
    if hops=='HELP'
       cmd=hops
    end
    if cmd!=nil
      cmd.upcase!
    end
    puts "got #{hops} - #{cmd}"
    #puts @index
    if hops=="RELOAD"
      reloadData()
    elsif getRow(hops) != nil || hops=='HELP'
      m.reply "#{m.user.nick}: #{getHops(hops,cmd)}"
    else
      m.reply "#{m.user.nick}, you be crazy fool. #{hops} doesn't exist!"
    end
  end
end
