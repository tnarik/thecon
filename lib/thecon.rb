require "thecon/version"

require 'timeout'
require 'socket'

module Thecon
  # Your code goes here...
  def test(ip = "85.205.228.219")
  	result = false
		begin
  		timeout(20) do
        s = Socket.new :INET, :STREAM
        #a = Socket.pack_sockaddr_in 80, "www.google.com"
        a = Socket.pack_sockaddr_in 2401, ip
        s.connect a
        begin
          #s.recvfrom_nonblock(2)
          #leo = s.read
          #p "fin de la primera parte" if (leo == "")   #External from home for 2401, "85.205.228.219"
          
          timeout(5) do

            r,w,e = select([s], nil, nil, 1)
            # nil, nil, nil from inside the network
            unless r.nil?  then
              p "socket was closed" if ( r[0].read(1).nil? )
            else
              p "not available for read: either doesn't exist or not closed"
            end
            p "hi try"
            if ( s.read == "") then
              p "fin de la primera parte" #closed externally
            else
              result = true
            end
          end
          p "he leido"
        rescue StandardError => ka
          p ka
        rescue Timeout::Error => e
          p "timedout reading"
        end

        # rescue Timeout::Error , StandardError => e#Exception => e
        #  #if (e.message == "execution expired")
        #  #  p "received? #{e.exception}"    # When reading from a server that doesn't send, which is quite normal
        #  #else
        #  #  raise e
        #  #end
        #  p "goatchas"
        #end
        result = true
      end
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      p "a"
      result=false
    rescue Timeout::Error, StandardError => e
      # This will happen when connection is imposible
      p "connection:  #{e}"   # When host or port is wrong
      result=false
    rescue
    end
    return result
  end

end
