require "twitter"
require "./devicepool"
class Twitfibot
  
  
  
  def initialize()
    @devicepool=DevicePool.new()
    @verbose=false
    @emulate=false
  end

  def setTwitterCredentials(consumer_key,consumer_secret,access_token,access_token_secret)  
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = consumer_key
      config.consumer_secret     = consumer_secret
      config.access_token        = access_token
      config.access_token_secret = access_token_secret
    end
  end  

  def parseCredentialFile(filename)
    begin
      file = File.open(filename)
    rescue
      puts "[Error] cannot find credential file #{filename}"
      puts "Credential file expected format: \n consumer_key=XXXXXX\n consumer_secret=XXXXXX\n access_token=XXXXXX\n access_token_secret=XXXXXX"
      return false
    end
    
    consumer_key=nil
    consumer_secret=nil
    access_token=nil
    access_token_secret=nil
    file.each do |line|
      #puts line
      token,value=line.chomp.split('=')
      #puts "[#{token}]  [#{value}]" 
      case token
      when  "consumer_key"
        consumer_key=value
      when  "consumer_secret"
        consumer_secret=value
      when  "access_token"
        access_token=value
      when  "access_token_secret"
        access_token_secret=value
      else
        puts "[Error] Unrecognized token: #{token}"
        return false
      end
    end
    
    return consumer_key,consumer_secret,access_token,access_token_secret
  end

  def loadTwitterCredentialsFromFile(filename) 
    
    consumer_key,consumer_secret,access_token,access_token_secret = parseCredentialFile(filename)

    if (consumer_key!=nil && consumer_secret != nil && access_token != nil && access_token_secret !=nil)
      setTwitterCredentials(consumer_key,consumer_secret,access_token,access_token_secret) 
    else
      puts "[Error] cannot read credentials from file #{filename}"
      return false
    end

  end

  def parse_line(line)
    array = line.split(';')
    time = Time.parse(array[0])
    sa = array[1].upcase
    da= array[2].upcase
    ss = array[3]
    ssid = array[4].chomp
    if(ss == '') then 
      ss = 0
    end
    return  time, sa, da, ss, ssid
  end
  
  
  def setEmulate(e)
    @emulate=e
  end
  def cleanUp()
    events = @devicepool.cleanUp()
    events.each do |event|
      tweet(event)
    end
    
  end
  
  def update(line)
    
    
    if line!=nil && line.chomp().length >0 then
      begin
        puts "bot::#{line}" if @verbose
        time, sa, da, ss, ssid = parse_line(line)
        events = @devicepool.update(time,sa,da,ss,ssid)
        events.each do |event|
          tweet(event)
        end
      rescue Exception => e  
        puts "[Error] Problem encountered while processing line: #{line}"
        puts e.message  
        puts e.backtrace.inspect  
      end
    end
    cleanUp()
  end
  
  
  def tweet(m)
    puts "Tweeting: \"#{m}\""
    
    @client.update(m) unless @emulate
    
  end

end  
