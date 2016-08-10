#!/usr/bin/env ruby
require 'cinch'
require 'cinch/plugins/dice'
require 'cinch/plugins/urbandictionary'
require 'cinch/plugins/downforeveryone'
require './nick.rb'
require './yeast.rb'
require './hops.rb'
require './untappdSearch.rb'
require './ping.rb'
require './slap.rb'
require './weather.rb'
require './tinyurl.rb'
require './seen.rb'
require './convert.rb'
require './twitter.rb'
require './lmgtfy.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#homebrewtalk.com","#r/homebrewing"]
    #c.channels = ["#brewbottest"]
    c.nick = "homebrewbot"
    c.plugins.plugins = [LMGTFY,UntappdSearch,Ping,Slap,Weather,Tinyurl,Nick,Seen,Convert,Cinch::Plugins::Dice,Cinch::Plugins::UrbanDictionary,Cinch::Plugins::DownForEveryone,Yeast,Hops]
  end

  on :message, "!help" do |m|
    if(m.bot.nick != "homebrewbot" && !m.bot.user_list.find("homebrewbot"))
      m.bot.nick="homebrewbot"
    end
    @help=[]
    @bot.plugins.each do |plugin|
      help = plugin.class.instance_variable_get(:@help)
      if help!=' '
        @help.push(help)
      end
    end
    m.reply @help.join(', ')
  end

end

bot.start
