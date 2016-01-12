#!/usr/local/bin/ruby

require 'rubygems'
require 'cinch'
require 'open-uri'
require 'uri'

class Yeast
  include Cinch::Plugin
  @help="!yeast"
  match /yeast (.+)/
  
  def initialize(*args)
    super
    
  end
  
  def execute(m,yeast)
    if (yeast != ' ')
      params = {
        'strain' => yeast
      }
      
      uri = URI.parse("http://brewerwall.com/api/v1/yeasts")
      response = Net::HTTP.post_form(uri,params)
      
      results = JSON.load(response.body)
      
      m.reply "#{results[0]["laboratory"]} #{results[0]["strain"]}: #{results[0]["name"]}; Temperature: #{results[0]["temperature_min"]}-#{results[0]["temperature_max"]}; Attenuation: #{results[0]["attenuation_min"]}-#{results[0]["attenuation_max"]}; Tolerance: #{results[0]["tolerance"]}%; Flocculation: #{results[0]["flocculation"]}"
    end
  end
end