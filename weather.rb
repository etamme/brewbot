#!/usr/local/bin/ruby
require 'net/http'
require 'uri'
require 'cinch'
require 'rubygems'
require 'xmlsimple'

class Weather
  include Cinch::Plugin
  @help="!weather"
  match /weather (.+)/

  def execute(m,location)
    location=location.gsub(' ','+')
    xml=Net::HTTP.get(URI.parse("http://www.google.com/ig/api?weather=#{location}"))

   data = XmlSimple.xml_in(xml)
   weather = data["weather"][0]
   forcast_info=weather["forecast_information"][0]
   conditions=weather["current_conditions"][0]
   details=weather["forecast_conditions"][0]
   
   city=forcast_info["city"][0]["data"]
   ccond=conditions["condition"][0]["data"]
   ctemp=conditions["temp_f"][0]["data"]
   chum=conditions["humidity"][0]["data"]
   low=details["low"][0]["data"]
   high=details["high"][0]["data"]
   m.reply "#{city}: #{ccond} #{ctemp}F #{chum} low: #{low} high: #{high}"
  end
end
