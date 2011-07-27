#!/usr/local/bin/ruby
require 'yaml'
require 'cinch'

class Nick

  include Cinch::Plugin

  match /nick (.+)/ 
  @nickData={}
  @nameIndex={}

  def storeData()
    File.open("./nickData.yaml", "w") do |file|
      file.puts YAML::dump(@nickData)
      file.puts ""
    end
  end

  def loadData()
    $/="\n\n"
    dataArray=[]
    @nickData={}
    @nameIndex={}
    File.open("./nickData.yaml", "r").each do |object|
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
    output=""
    cmd,val = cmdstr.split(' ',2)
    if val==nil
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
        output="Show me yours first."
      end
    elsif(cmd=='set')
      @nickData[m.user.nick]=val
      @nameIndex[val]=m.user.nick
      storeData()
      output="Thanks "+m.user.nick+".  Now I know who you are."
    else
      output="What's that now?  I don't understand."
    end
    m.reply "#{m.user.nick}, #{output}"
  end
end
