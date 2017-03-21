#!/usr/local/bin/ruby
require 'cinch'
require 'date'
require 'time'
require 'yaml'

class Seen
  include Cinch::Plugin
  @help="!seen"
  match(/(.+)/,{:use_prefix => false})

  def initialize(*args)
    super
    curdir = File.dirname(__FILE__);

    @last=YAML.load_file( "#{curdir}/seen.yaml")
    puts "@last is #{@last}"
    if(@last==nil)
      @last={}
    end
  end


  def time_in_words(minutes)
    case
      when minutes < 1
        "less than a minute"
      when minutes < 50
        if minutes > 1
          "#{minutes} minutes"
        else
          "#{minutes} minute"
        end
      when minutes < 90
        "about one hour"
      when minutes < 1080
      "#{(minutes / 60).round} hours"
      when minutes < 1440
        "one day"
      when minutes < 2880
        "about one day"
      else
       "#{(minutes / 1440).round} days"
    end
  end


  def execute(m,arg)
    if(m.bot.nick != "homebrewbot")
      if(m.bot.user_list.find("homebrewbot"))
        return 0
      else
        m.bot.nick="homebrewbot"
      end
    end

     if( arg =~ /^!seen (.+)$/ )
       curtime=Time.now()
       if @last[$1.downcase] != nil
         oldtime=Time.parse(@last[$1.downcase][0])
         timediff=curtime-oldtime
        # puts timediff
         if timediff<60
           timediff=0
         else
           timediff=(timediff/60).to_i
         end
         m.reply "#{$1} was last seen #{time_in_words(timediff)} ago saying: #{@last[$1.downcase][1]}"
       else
         m.reply "I haven't seen #{$1} since I last joined the channel"
       end
     else
       @last[m.user.nick.downcase]=[Time.now.strftime("%Y-%m-%d %H:%M:%S"),arg]
       File.open( 'seen.yaml', 'w' ) do |out|
         YAML.dump( @last, out )
       end
     end
  end
end
