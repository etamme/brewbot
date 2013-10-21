#!/usr/local/bin/ruby
require 'net/http'
require 'uri'
require 'cinch'
require 'rubygems'
require 'xmlsimple'

class Twitter
  include Cinch::Plugin

  @help="!twitter"

  match /twitter (.+)/

  def execute(m,screenname)
    if(m.bot.nick != "homebrewbot")
      if(m.bot.user_list.find("homebrewbot"))
        return 0
      else
        m.bot.nick="homebrewbot"
      end
    end
    screenname=screenname.gsub(' ','+')
    uri="http://api.twitter.com/1/statuses/user_timeline.xml?include_entities=true&include_rts=false&screen_name=#{screenname}&count=1"
    puri=URI.parse(uri)
    xml=Net::HTTP.get(puri)
    data = XmlSimple.xml_in(xml)
    status = data["status"][0]
    tweet = status["text"][0]
    m.reply "@#{screenname}: #{tweet}"
  end
end
