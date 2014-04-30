#!/usr/bin/ruby1.9.1 -w
require "./twitfibot"
consumer_key = ""
consumer_secret = ""
access_token = ""
access_token_secret = ""


bot=Twitfibot.new()
bot.initializeTwitterAccount(consumer_key,consumer_secret,access_token,access_token_secret)
#bot.setSilent(true)


ARGF.each do |line|
  #puts line
  bot.update(line)
end
