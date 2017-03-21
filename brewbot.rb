#!/usr/bin/env ruby

curdir = File.dirname(__FILE__);

require 'cinch'
require 'cinch/plugins/dice'
require 'cinch/plugins/urbandictionary'
require 'cinch/plugins/downforeveryone'
require "#{curdir}/nick.rb"
require "#{curdir}/yeast.rb"
require "#{curdir}/hops.rb"
require "#{curdir}/untappdSearch.rb"
require "#{curdir}/ping.rb"
require "#{curdir}/slap.rb"
require "#{curdir}/weather.rb"
require "#{curdir}/tinyurl.rb"
require "#{curdir}/seen.rb"
require "#{curdir}/convert.rb"
require "#{curdir}/twitter.rb"
require "#{curdir}/lmgtfy.rb"

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#homebrewtalk.com","#r/homebrewing"]
    #c.channels = ["#brewbottest"]
    c.nick = "homebrewbot"
    c.plugins.plugins = [Ping,UntappdSearch,Weather,Seen,Convert,Yeast,Hops,Slap,LMGTFY,Tinyurl,Nick,Cinch::Plugins::Dice,Cinch::Plugins::UrbanDictionary,Cinch::Plugins::DownForEveryone]
  end

  on :message, "!help" do |m|
    if(m.bot.nick != "homebrewbot" && !m.bot.user_list.find("homebrewbot"))
      m.bot.nick="homebrewbot"
    end
    @help=[]
    @bot.plugins.each do |plugin|
      help = plugin.class.instance_variable_get(:@help)
      if !help.nil?
        @help.push(help)
      end
    end
    m.reply @help.join(', ')
  end

end

bot.start
