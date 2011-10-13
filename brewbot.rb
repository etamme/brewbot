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
    c.plugins.plugins = [Nick,GSYeast,Ratebeer,Ping,Slap,Weather,Tinyurl,Seen,Convert]
  end
end

bot.start

