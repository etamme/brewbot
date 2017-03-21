#!/usr/local/bin/ruby

require 'rubygems'
require 'cinch'
require 'open-uri'
require 'uri'
require 'yaml'

class UntappdSearch
  include Cinch::Plugin
  @help="!beerscore"
  @untappd_urls=[]
  match /beerscore (.+)/

  def initialize(*args)
    super
    curdir = File.dirname(__FILE__);
    # load config from yaml file
    @untappd_config = YAML::load_file("#{curdir}/untappd.yaml")

    @id = @untappd_config['id']
    @secret = @untappd_config['secret']
  end

  def getURL(node, params)
    urls = {
      "beer"        => "https://untappd.com/b",
      "beer_search" => "https://api.untappd.com/v4/search/beer",
      "beer_score"  => "https://api.untappd.com/v4/beer/info"
    }
    url = urls[node]
    query = "?client_id=#{@id}&client_secret=#{@secret}"

    if(params.is_a?(Hash))
        params.each do |param,value|
          query = query + "&#{param}=#{value}"
        end
    elsif(params.is_a?(Array))
      params.each do |value|
        url = "#{url}/#{value}"
      end
    else
      url = "#{url}/#{params}"
    end

    url = url + query

    return url
  end

  def execute(m,beer)
    if(m.bot.nick != "homebrewbot")
      if(m.bot.user_list.find("homebrewbot"))
        return 0
      else
        m.bot.nick="homebrewbot"
      end
    end

    params = {
      'q' => beer,
      'limit' => '5'
    }

    search_url = getURL('beer_search',params)

    results = JSON.load(URI.parse(URI.encode(search_url)))

    results["response"]["beers"]["items"].each do |result|
      score_url = getURL('beer_score', result["beer"]["bid"].to_s)
      score = JSON.load(URI.parse(URI.encode(score_url)))

      rating = score["response"]["beer"]["rating_score"]

      params = [
        score["response"]["beer"]["beer_slug"],
        score["response"]["beer"]["bid"]
      ]
      link = getURL('beer', params)

      tinyurl=Net::HTTP.get(URI.parse("http://tinyurl.com/api-create.php?url=#{link}"))

      m.reply "#{rating.round(2)} for #{result["beer"]["beer_name"]} by #{result["brewery"]["brewery_name"]}, #{tinyurl}"
    end
  end
end
