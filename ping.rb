#!/usr/local/bin/ruby

require 'cinch'

class Ping
  include Cinch::Plugin
  @help="."
  match(/^\.$/,{:use_prefix => false})
  def execute(m)
      m.reply ".." 
  end
end
