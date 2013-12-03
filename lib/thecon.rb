require "thecon/version"

require 'timeout'
require 'socket'

module Thecon
  # Your code goes here...
  def self.test(port=2401, ip = "85.205.228.219")
  	result = false
		begin
  		timeout(6) do
        s = Socket.new :INET, :STREAM
        a = Socket.pack_sockaddr_in port, ip
        s.connect a
        begin
          timeout(3) do

            r,w,e = select([s], nil, nil, 1) # nil, nil, nil from inside the network
            unless r.nil?  then
              p "socket was closed" if ( r[0].read(1).nil? ) #This means there is something there
            else
              p "not available for read: either doesn't exist or not closed"
            end

            if ( s.read == "") then
              p "closed " #closed externally
            else
              result = true
            end
          end
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
      p "connection refused"
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
