#!/usr/local/bin/ruby

require 'cinch'
require 'csv'
require 'uri'
require 'net/http'
require 'json'

class Beerscore
  include Cinch::Plugin

  match /beerscore (.+)/

  @yeastData={}

  def execute(m,beer)
    baseuri="http://caedmon.net/beerscore/"
    uri = URI.escape("#{baseuri}#{beer}")
    resp=Net::HTTP.get_response(URI.parse(uri))
    data = resp.body
    if data.include? 'No results'
      output="#{m.user.nick}, Sorry.  I couldn't find #{beer}."
    elsif data.include? 'REFINE'
      output="#{m.user.nick}, Sorry.  I couldn't find #{beer}. Try refining your search."
    else
      # we convert the returned JSON data to native Ruby
      # data structure - a hash
      result = JSON.parse(data)
      beer={}
      beer=result['beer'][0]
      output="#{m.user.nick}, #{beer['name']}: #{beer['url']} score: #{beer['score']} style score: #{beer['stylescore']}"
    end
    m.reply output 
  end
end
