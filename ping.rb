#!/usr/local/bin/ruby

require 'cinch'

class Ping
  include Cinch::Plugin
  @help="."
  match(/^\.$/,{:use_prefix => false})
  def execute(m)
    if(m.bot.nick != "homebrewbot")
      if(m.bot.user_list.find("homebrewbot"))
        return 0
      else
        m.bot.nick="homebrewbot"
      end
    end
   m.reply ".." 
  end
end
