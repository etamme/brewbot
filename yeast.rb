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
      
      if (results.empty?)
        m.reply "Sorry #{m.user.nick}, no yeast was found matching \"#{yeast}\"."
      else 
        if (results.count == 1)
          results.each do |result|
            m.reply "#{result["laboratory"]} #{result["strain"]}: #{result["name"]}; Temperature: #{result["temperature_min"]}-#{result["temperature_max"]}; Attenuation: #{result["attenuation_min"]}-#{result["attenuation_max"]}; Tolerance: #{result["tolerance"]}%; Flocculation: #{result["flocculation"]}"
          end
        elsif
          yeast = Array.new
          
          results.each do |result|
            yeast.push("#{result["strain"]} - #{result["name"]}")
          end
          
          m.reply "#{m.user.nick} there are multiple options. Please try again with the strain number:"
          m.reply yeast.join('; ')
        end
      end
    end
  end
end