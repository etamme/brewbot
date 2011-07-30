#!/usr/local/bin/ruby
require 'net/http'
require 'net/http'
require 'hpricot'
require 'uri'
require 'cinch'

class Weather
  include Cinch::Plugin

  match /weather (.+)/

  def execute(m,location)
    location=location.gsub(' ','+')
    xml=Net::HTTP.get(URI.parse("http://www.google.com/ig/api?weather=#{location}"))

    doc = Hpricot::XML(xml)
   (doc/:current_conditions).each do |status|
     first=true
     (status/"*").each do |el|
       if first
         first=false
       else
         m.reply el.to_s
             #m.reply "#{el}: #{status.at(el).innerHTML}"
       end
     end
    end
  end
end
