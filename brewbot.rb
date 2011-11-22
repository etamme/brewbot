#!/usr/bin/env ruby
require 'cinch'
require './nick.rb'
require './gsyeast.rb'
require './ratebeer.rb'
require './ping.rb'
require './slap.rb'
require './weather.rb'
require './tinyurl.rb'
require './seen.rb'
require './convert.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
#    c.channels = ["#homebrewtalk.com"]
    c.channels = ["#fasd"]
    c.nick = "homebrewbot"
    c.plugins.plugins = [Ratebeer,Ping,Slap,Weather,Tinyurl,Nick,GSYeast,Seen,Convert]
  end
  
  on :message, "!help" do |m|
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

