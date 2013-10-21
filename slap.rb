#!/usr/local/bin/ruby

require 'cinch'

class Slap
  include Cinch::Plugin
  @help="!slap"
  match(/slap (.+)/)#,{:use_prefix => false})
  def execute(m,user)
    if(m.bot.nick != "homebrewbot")
      if(m.bot.user_list.find("homebrewbot"))
        return 0
      else
        m.bot.nick="homebrewbot"
      end
    end

    if m.user.nick=="lirakis" || m.user.nick=="gremlyn"
      5.times do |x|
        m.reply "*brewbot slaps #{user}"
      end
    else
      m.reply "I only do my masters bidding"
      m.reply "*brewbot slaps #{m.user.nick}"
    end
  end
end
