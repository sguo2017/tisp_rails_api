require 'socket'
class Utils::ServerUtils
  class << self  # 在下面定义的方法属于静态方法
  
    def get_server_ip
      address_info = Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}
      if address_info
        return address_info.ip_address
      else 
        return local_ip
      end
    end
	
    private
      def local_ip
        orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily
        UDPSocket.open do |s|
          s.connect '8.8.8.8', 1
          s.addr.last
        end
      ensure
        Socket.do_not_reverse_lookup = orig
      end
  end
end
