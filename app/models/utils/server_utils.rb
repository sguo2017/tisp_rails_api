require 'socket'
class Utils::ServerUtils
  class << self  # 在下面定义的方法属于静态方法
  
    def get_server_ip
      address_info = Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}
	  return address_info.ip_address
    end
	
  end
end