#!/usr/local/bin/ruby

require 'cinch'
require 'net/http'
require 'uri'


class Tinyurl
  include Cinch::Plugin
  @@last={}
  match(/(!tiny)|(http.+)/,{:use_prefix => false})
  def execute(m,cmd=nil,url=nil)
     if( url!=nil && url.include?("http"))
       @@last[m.user.nick]=url
     elsif cmd=="!tiny"
       tinyurl=Net::HTTP.get(URI.parse("http://tinyurl.com/api-create.php?url=#{@@last[m.user.nick]}"))
       m.reply tinyurl
     end
  end
end
