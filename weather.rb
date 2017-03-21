#!/usr/local/bin/ruby
require 'cinch'
require 'net/http'
require 'uri'
require 'rubygems'
require 'yaml'
require 'wunderground'

class Weather
  include Cinch::Plugin
  @help="!weather"
  match /weather (.+)/

  def initialize(*args)
    super
    curdir = File.dirname(__FILE__);
    # load config from yaml file
    @weather_config=[]
    File.open("#{curdir}/weather.yaml",'r').each do |object|
      @weather_config << YAML::load(object)
    end
    @key=@weather_config.first['key']
  end

  def execute(m,location)
    if(m.bot.nick != "homebrewbot")
      if(m.bot.user_list.find("homebrewbot"))
        return 0
      else
        m.bot.nick="homebrewbot"
      end
    end

    location=location.gsub(' ','_')

    wunder_api = Wunderground.new(@key)
    weather = wunder_api.conditions_for(location)

    if (weather['response']['results'] != nil)
      location = weather['response']['results'][0]['zmw']
      weather = wunder_api.conditions_for(location)
    end

    current = weather['current_observation']

    city = current['display_location']['full']
    ccond = current['weather']
    ctemp = current['temperature_string']
    chum = current['relative_humidity']
    url = current['forecast_url'] + "?apiref=20612905a9c0054a"
    tinyurl=Net::HTTP.get(URI.parse("http://tinyurl.com/api-create.php?url=#{url}"))
    m.reply "#{city}: #{ccond}, #{ctemp} with #{chum} relative humidity. See the forecast: #{tinyurl}"
  end
end
