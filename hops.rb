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
      
      results.each do |result|
        m.reply "#{result["name"]} - Origin: #{result["origin"]}; Alpha Acid: #{result["alpha_min"]}-#{result["alpha_max"]}; Aroma: #{result["aroma"]}; Styles: #{result["styles"]}}"
      end
    end
  end
end