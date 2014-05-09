#!/usr/bin/ruby1.9.1 -w
require 'trollop'
require "./twitfibot"

credential_file="./twitter_credentials.txt"
emulate=true
from_file=false
interface="wlan0"

opts = Trollop::options do
  version "twitfi_bot 0.1 (c) 2014 Mathieu Cunche"
  banner <<-EOS
This is a program that collect information contained in 802.11 probe requests and post them on Twitter.

Usage:
       run_twitfibot.rb [options]
where [options] are:
EOS

  opt :emulate, "Emulate message posting to twitter (i.e. don't post anything)", :default => true
  opt :verbose, "Enable verbose mode", :default => false
  opt :capfile, "File containing probe request data (optional)",
        :type => String
  opt :credfile, "File containing the twitter credentials (optional)",
        :type => String, :default => "./twitter_credentials.txt"
  opt :interface, "Name of the wireless interface. Ex. wlan0. (optional)", :type => String, :default => "wlan0" 
end

from_file=true if opts[:capfile]

#Trollop::die :credfile, "must exist" unless File.exist?(opts[:credfile]) if opts[:credfile]

capture_file = opts[:capfile]

bot=Twitfibot.new()
bot.setVerbose(opts[:verbose]) 
bot.loadTwitterCredentialsFromFile(opts[:credfile])
bot.setEmulate(opts[:emulate]) 


if(opts[:capfile]) then 
  bot.run_from_file(opts[:capfile])
else
  bot.run_live(opts[:interface])
end

