#!/usr/local/bin/ruby
require 'cinch'
require 'rubygems'
require 'yaml'
require 'wunderground'

class Weather
  include Cinch::Plugin
  @help="!weather"
  match /weather (.+)/

  def initialize(*args)
    super
    # load config from yaml file
    @weather_config=[]
    File.open('weather.yaml','r').each do |object|
      @weather_config << YAML::load(object)
    end
    @key=@weather_config.first['key']
  end

  def execute(m,location)
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
    url = current['forecast_url']
    m.reply "#{city}: #{ccond}, #{ctemp} with #{chum} relative humidity."
    m.reply "See the forecast: #{url}?apiref=20612905a9c0054a"
  end
end
