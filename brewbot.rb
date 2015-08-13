#!/usr/bin/env ruby
require 'cinch'
require './nick.rb'
#require './gdyeast.rb'
#require './gdhops.rb'
require './untappdSearch.rb'
require './ping.rb'
require './slap.rb'
require './weather.rb'
require './tinyurl.rb'
require './seen.rb'
require './convert.rb'
require './twitter.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
#    c.channels = ["#homebrewtalk.com"]
    c.channels = ["#brewbottest"]
    c.nick = "homebrewbot"
    c.plugins.plugins = [UntappdSearch,Ping,Slap,Weather,Tinyurl,Nick,Seen,Convert]#,GDYeast,GDHops]
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

