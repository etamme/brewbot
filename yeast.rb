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
  
  def searchYeast(params)
    uri = URI.parse("http://brewerwall.com/api/v1/yeasts")
    response = Net::HTTP.post_form(uri,params)
      
    results = JSON.load(response.body)
      
    return results
  end
  
  def execute(m,yeast)
    if (yeast != ' ')
      params = {
        'strain' => yeast
      }
            
      results = searchYeast(params)
      
      if (results.empty?)
        params = {
          'name' => yeast
        }
        
        results = searchYeast(params)
      end

      results.each do |result|
        m.reply "#{result["laboratory"]} #{result["strain"]}: #{result["name"]}; Temperature: #{result["temperature_min"]}-#{result["temperature_max"]}; Attenuation: #{result["attenuation_min"]}-#{result["attenuation_max"]}; Tolerance: #{result["tolerance"]}%; Flocculation: #{result["flocculation"]}"
      end
    end
  end
end