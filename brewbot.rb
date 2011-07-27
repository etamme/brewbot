#!/usr/bin/env ruby
require 'cinch'
require './nick.rb'
require './yeast.rb'
require './beerscore.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
#    c.channels = ["#homebrewtalk.com"]
    c.channels = ["#fasd"]
    c.nick = "brewbot"
    c.plugins.plugins = [Nick,Yeast,Beerscore]
  end
end

bot.start

