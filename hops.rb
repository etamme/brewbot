#!/usr/local/bin/ruby

require 'rubygems'
require 'cinch'
require 'open-uri'
require 'uri'

class Hops
  include Cinch::Plugin
  @help="!hops"
  match /hops (.+)/
  
  def initialize(*args)
    super
    
  end
  
  def execute(m,hops)
    if (hops != ' ')    
      params = {
        'name' => hops
      }
      
      uri = URI.parse("http://brewerwall.com/api/v1/hops")
      response = Net::HTTP.post_form(uri,params)
      
      results = JSON.load(response.body)
      
      if (results.empty?)
        m.reply "Sorry #{m.user.nick}, no hops were found matching \"#{hops}\"."
      elsif (results.count == 1)
        results.each do |result|
          m.reply "#{result["name"]} - Origin: #{result["origin"]}; Alpha Acid: #{result["alpha_min"]}-#{result["alpha_max"]}; Aroma: #{result["aroma"]}; Styles: #{result["styles"]}"
        end
      elsif (results.count == 2 && results[0]['name'] == results[1]['name'])
        results.each do |result|
          m.reply "#{result["name"]} - Origin: #{result["origin"]}; Alpha Acid: #{result["alpha_min"]}-#{result["alpha_max"]}; Aroma: #{result["aroma"]}; Styles: #{result["styles"]}"
        end
      else
        hop = Array.new
          
        hops = results.take(10)
          
        hop_count = hops.count
          
        hops.each do |result|
          hop.push("#{result["name"]}")
        end
          
        m.reply "#{m.user.nick} there are multiple options, here are #{hop_count} to choose from."
        m.reply hop.join('; ')
      end
    end
  end
end