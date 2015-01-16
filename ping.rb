#!/usr/local/bin/ruby

require 'cinch'

class Ping
  include Cinch::Plugin
  @help="."
  match(/^\.$/,{:use_prefix => false})
  def execute(m)
    if(m.bot.nick != "homebrewbot" && !m.bot.user_list.find("homebrewbot"))
      m.bot.nick="homebrewbot"
    end
   m.reply ".." 
  end
end
