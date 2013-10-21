#!/usr/local/bin/ruby

require 'rubygems'
require 'cinch'
require 'net/http'
require 'iconv'
require 'hpricot'
require 'uri'

class Ratebeer
  include Cinch::Plugin
  @help="!beerscore"
  match /beerscore (.+)/
  def execute(m,beer)
    if(m.bot.nick != "homebrewbot")
      if(m.bot.user_list.find("homebrewbot"))
        return 0
      else
        m.bot.nick="homebrewbot"
      end
    end

    page=Net::HTTP.post_form(URI.parse('http://www.ratebeer.com/findbeer.asp'),{'BeerName' => beer})
    body=page.body.gsub(/[\x80-\xff]/,"")
    doc = Hpricot(body)
    total=0
    (doc/"table.results//tr").each do |row|
        score=""
        link=""
        name=""
        td=1
        (row/"td").each do |cell|
          if td==4
            if cell.to_s.scan(/([0-9]+)/)
              score=$1
            else
              score="NO SCORE"
            end
          end

          (cell/"a").each do |href|
            if href.to_s.include? "View more"
              href.to_s.scan(/(\/beer.+\/)\W title="View more info on (.+)"/)
              link=$1
              name=$2
            end
          end
          td=td+1
        end
        if link!="" && (score!=nil && score.strip !="")
          total=total+1
          if total<6
            pad=50-name.length
            padding=""
            pad.times do |x| 
              padding=padding+" " 
            end
            tinyurl=Net::HTTP.get(URI.parse("http://tinyurl.com/api-create.php?url=http://www.ratebeer.com#{link}"))
            m.reply "#{name}#{padding}score: #{score}  #{tinyurl}"
          end
       end
    end
  end
end
