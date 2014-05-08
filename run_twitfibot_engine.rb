#!/usr/bin/ruby1.9.1 -w
require "./twitfibot"
credential_file="./twitter_credentials.txt"

bot=Twitfibot.new()
bot.loadTwitterCredentialsFromFile(credential_file)
bot.setEmulate(true)


ARGF.each do |line|
  #puts line
  bot.update(line)
end
