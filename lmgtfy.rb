#!/usr/local/bin/ruby

require 'cinch'
require 'net/http'
require 'open-uri'

class LMGTFY
  include Cinch::Plugin
  @help="!lmgtfy your query"
  match /lmgtfy (.+)/

  def execute(m, query)
    if(m.bot.nick != "homebrewbot" && !m.bot.user_list.find("homebrewbot"))
      m.bot.nick="homebrewbot"
    end

    url = "http://lmgtfy.com/?q=#{query}"
    url = URI::encode(url)

    tinyurl = Net::HTTP.get(URI::parse("http://tinyurl.com/api-create.php?url=#{url}"))

    m.reply tinyurl
  end

end
