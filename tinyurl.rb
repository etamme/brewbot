#!/usr/local/bin/ruby

require 'cinch'
require 'net/http'
require 'uri'


class Tinyurl
  include Cinch::Plugin
  match(/(http.+)/,{:use_prefix => false})
  def execute(m,url)
     if(url.length>50 and (!url.include?("tinyurl")))
       tinyurl=Net::HTTP.get(URI.parse("http://tinyurl.com/api-create.php?url=#{url}"))
       m.reply tinyurl
     end
  end
end
