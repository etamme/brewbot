#!/usr/bin/env ruby
require 'cinch'
require './nick.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#fasd"]
    c.nick = "brewbot"
    c.plugins.plugins = [Nick]
  end
end

bot.start

