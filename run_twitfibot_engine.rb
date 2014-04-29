#!/usr/bin/ruby1.9.1 -w
require "./twitfibot"
# @Cunchem
#consumer_key        = "HpbeO3VDO9UTIWKucVUYa8nVl"
#consumer_secret     = "im2E1ryorkujv3f8NRMGHp6Q6XRCBByqVwXQglMXlBAfzXsCG7"
#access_token        = "102025640-sOy8igwLVKHbe3uoIbvKjcNKOskLEyQM66VASAl0"
#access_token_secret = "XwOxVt4fBBVnFtGKwjzUwNYKl3ndHGqdIcnpV7AcpxDmP"
# @twitfibot
consumer_key        = "SNWOM3KCviH4F9vt6ZO9Pdzda"
consumer_secret     = "83x15lOWIaOn6abnD1M4zZf2mAkOfjfSpb6PO39yILzWvgmKIz"
access_token        = "2464572090-xIhuY5vdMdGvebxs0ZFussya4flwqEL5b72WBTg"
access_token_secret = "w3moDAv96JL47sThhRg1MXDFl7dK5a2112Wnb7A2u12EG"


bot=Twitfibot.new()
bot.initializeTwitterAccount(consumer_key,consumer_secret,access_token,access_token_secret)
#bot.setSilent(true)


ARGF.each do |line|
  #puts line 
  bot.update(line)
end
