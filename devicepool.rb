require "./device"
class DevicePool

  def initialize()
    @devices=[]
    @timeout=120
  end
  def cleanUp()
    t = Time.now
    
    events = []
    @devices.each do |device|
      if (t - device.get_time > @timeout ) then 
        @devices.delete(device)
        events += [leavingDeviceEvent(device)]
      end 
    end
    return events
  end
  
  def searchdevice(sa)
    @devices.each do |device|
      if(device.mac == sa) then
        return device
      end
    end
    return nil
  end
  def leavingDeviceEvent(device)
    return "Leaving device #{device.macanon} #{device.vendor}. Bye bye." 
  end
  def newDeviceEvent(device) 
    return "Hello new device #{device.macanon} #{device.vendor}"
  end
  def newSsidEvent(device,ssid)
    return "New SSID #{ssid} for device #{device.macanon} #{device.vendor}"
  end
  def update(time, sa, da, ss, ssid)
    events = []
    device = searchdevice(sa)
    if(device == nil) then
      device = Device.new(time, sa, da, ss, ssid)
      @devices+=[device]
      events += [newDeviceEvent(device)]
      if(ssid.length > 0) then
        events += [newSsidEvent(device,ssid)]
      end
    else
      res = device.update(time,ss,ssid)
      if(res) then
        events += [newSsidEvent(device,ssid)]
      end
    end
    return events
  end
end    
