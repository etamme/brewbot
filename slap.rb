#!/usr/local/bin/ruby

require 'cinch'

class Slap
  include Cinch::Plugin
  @help="!slap"
  match(/slap (.+)/)#,{:use_prefix => false})
  def execute(m,user)
    
    slaps = [
      "with a large, wet trout",
      "really fucking hard",
      "stupid bitch face",
      "like a lover in heat",
      "leaving a mushroom stamp",
      "then shits on the floor",
      "like a pansy",
      "with great zeal",
      "with wild abandon",
      "but cries a little on the inside",
      "half heartedly",
      "using a board with a nail in the end"
    ]
    
    if user=="lirakis" || user=="gremlyn"
      m.reply "I am programmed not to harm my masters!"
      m.action_reply "slaps #{m.user.nick} #{slaps.sample}"
    elsif m.user.nick=="lirakis" || m.user.nick=="gremlyn"
      m.action_reply "slaps #{user} #{slaps.sample}"
    else
      test = rand(10)
      
      if test == 1
        m.action_reply "slaps #{user} #{slaps.sample}"
      else
        m.reply "Sorry, not this time!"
        m.action_reply "slaps #{m.user.nick} #{slaps.sample}"
      end
    end
  end
end
