#!/usr/bin/ruby1.9.1 -w
require "./twitfibot"
require 'open3'

credential_file="./twitter_credentials.txt"

bot=Twitfibot.new()
bot.loadTwitterCredentialsFromFile(credential_file)
bot.setEmulate(true)

cmd = 'sudo tshark -l -i mon0  -R "wlan.fc.type_subtype == 4" -T fields -e frame.time    -e wlan.sa  -e wlan.da   -e radiotap.dbm_antsignal -e wlan_mgt.ssid -E separator=";"'
puts cmd
Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
  while line = stdout.gets
    puts line
    bot.update(line)
    
  end
end





