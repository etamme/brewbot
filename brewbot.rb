#!/usr/bin/env ruby
require 'cinch'
require './nick.rb'
require './yeast.rb'
require './ratebeer.rb'
require './ping.rb'
require './slap.rb'
require './weather.rb'
require './tinyurl.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#homebrewtalk.com"]
#    c.channels = ["#fasd"]
    c.nick = "homebrewbot"
    c.plugins.plugins = [Nick,Yeast,Ratebeer,Ping,Slap,Weather,Tinyurl]
  end
end

bot.start

