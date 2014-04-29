require "twitter"
require "./devicepool"
class Twitfibot
  
  

  def initialize()
    @devicepool=DevicePool.new()
    @silent=false
  end
  def initializeTwitterAccount(consumer_key,consumer_secret,access_token,access_token_secret)  
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
    end
  end  
  def parse_line(line)
    array = line.split(';')
    time = Time.parse(array[0])
    sa = array[1]
    da= array[2]
    ss = array[3]
    ssid = array[4].chomp
    if(ss == '') then 
      ss = 0
    end
    return  time, sa, da, ss, ssid
  end
  
  
  def setSilent(s)
    @silent=s
  end
  def cleanUp()
    events = @devicepool.cleanUp()
    events.each do |event|
      tweet(event)
    end
    
  end
  
  def update(line)
    puts "bot::#{line}"
    time, sa, da, ss, ssid = parse_line(line)
    events = @devicepool.update(time,sa,da,ss,ssid)
    events.each do |event|
      tweet(event)
    end
    cleanUp()
  end
  
  
  def tweet(m)
    puts "Tweeting: \"#{m}\""
    if(!@silent) then
      @client.update(m)
    end
  end

end  
