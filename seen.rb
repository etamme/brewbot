#!/usr/local/bin/ruby
require 'cinch'
require 'date'

class Seen
  include Cinch::Plugin
  @@last={}
  match(/(.+)/,{:use_prefix => false})

  def execute(m,arg)
     if( arg =~ /^!seen (.+)$/ )
       if @@last[$1.downcase] != nil
         m.reply "#{$1} was last seen at #{@@last[$1.downcase][0]} EST saying: #{@@last[$1.downcase][1]}"
       else
         m.reply "I haven't seen #{$1} since I last joined the channel"
       end
     else
       @@last[m.user.nick.downcase]=[Time.now.strftime("%Y-%m-%d %H:%M:%S"),arg]
     end
  end
end
