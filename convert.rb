#!/usr/local/bin/ruby
require 'cinch'
require 'net/http'
require 'uri'

class Convert
  include Cinch::Plugin
  @help="!convert"
  match(/convert (.+)/)
  def execute(m,arg)
    if(m.bot.nick != "homebrewbot")
      if(m.bot.user_list.find("homebrewbot"))
        return 0
      else
        m.bot.nick="homebrewbot"
      end
    end

       lhs=""
       rhs=""
       arg=arg.gsub(' ','+')
       data=Net::HTTP.get(URI.parse("http://www.google.com/ig/calculator?q=#{arg}"))
       # {lhs: "1 pound",rhs: "16 ounces",error: "",icc: false}
       data=data.gsub('{','')
       data=data.gsub('}','')
       kvps=data.split(',')
       kvps.each do |kvp|
         kvp=kvp.gsub('"','')
         arr = kvp.split(':')
         if arr[0]=="lhs"
            lhs=arr[1]
         elsif arr[0]=="rhs"
            rhs=arr[1]
         end
       end
       if lhs!=" " && rhs!=" "
         m.reply "#{lhs} is #{rhs}"
       else
         m.reply "Are you sure those measurements exist?"
       end
  end
end
