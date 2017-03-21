#!/usr/local/bin/ruby
require 'yaml'
require 'cinch'

class Nick

  include Cinch::Plugin
  @help="!nick"
  match /nick (.+)/
  @nickData={}
  @nameIndex={}

  def storeData()
    curdir = File.dirname(__FILE__);
    File.open("#{curdir}/nickData.yaml", "w") do |file|
      file.puts YAML::dump(@nickData)
      file.puts ""
    end
  end

  def loadData()
    $/="\n\n"
    dataArray=[]
    @nickData={}
    @nameIndex={}
    curdir = File.dirname(__FILE__);
    File.open("#{curdir}/nickData.yaml", "r").each do |object|
      dataArray << YAML::load(object)
    end
    dataArray.each do |hash|
      hash.each do |k,v|
        @nickData[k]=v
        @nameIndex[v]=k
      end
    end
  end

  def initialize(*args)
    super
    loadData()
  end

  def execute(m,cmdstr)
    if(m.bot.nick != "homebrewbot")
      if(m.bot.user_list.find("homebrewbot"))
        return 0
      else
        m.bot.nick="homebrewbot"
      end
    end

    output=""
    cmd,val = cmdstr.split(' ',2)
    if(val==nil && cmd!='reload')
      val=cmd
      cmd='get'
    end

    if(cmd=='reload')
      @nickData={}
      @nameIndex={}
      loadData()
      output="nick data reloaded"
    elsif(cmd=='get')
      if(@nickData[m.user.nick]!=nil)
        if(@nickData[val]!=nil || @nameIndex[val]!=nil)
          if(@nickData[val]!=nil)
            output=val+" is "+@nickData[val]
          else
            output=val+" is "+@nameIndex[val]
          end
        else
          output="Sorry.  I don't know who that is."
        end
      else
        output="Show me yours first. !nick set your name"
      end
    elsif(cmd=='set')
      if val==m.user.nick
        output="#{m.user.nick}, I dont think so.  Try again"
      else
        @nickData[m.user.nick]=val
        @nameIndex[val]=m.user.nick
        storeData()
        output="Thanks "+m.user.nick+".  Now I know who you are."
      end
    else
      output="What's that now?  I don't understand."
    end
    m.reply "#{m.user.nick}, #{output}"
  end
end
