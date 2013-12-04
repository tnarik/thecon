require "thecon/version"

require 'timeout'
require 'socket'

module Thecon
  # Your code goes here...
  def self.ready?(port=80, ip = "localhost", connection_timeout = 6, read_timeout = 2)
  	result = false
		begin
  		timeout( connection_timeout ) do
        socket = Socket.new :INET, :STREAM
        a = Socket.pack_sockaddr_in port, ip
        socket.connect a
        begin
          timeout( read_timeout ) do
            r,w,e = select([socket], nil, nil, 1) # nil, nil, nil from inside the network
            unless r.nil? then
              p "socket was closed" if ( r[0].read(1).nil? ) #This means there is something there
              result = false #Something closed this
            else
              p "not available for read: either doesn't exist or not closed" #TRUE
              result = true
            end

            if ( socket.read == "") then
              p "closed " #closed externally
            else
              result = true
            end
          end
        rescue StandardError => ka
          p "OK, standardERROR"
          p ka
          result = true
        rescue Timeout::Error => e
          p "timedout reading" #Socket is there but there are not data
          result = true
        end

        # rescue Timeout::Error , StandardError => e#Exception => e
        #  #if (e.message == "execution expired")
        #  #  p "received? #{e.exception}"    # When reading from a server that doesn't send, which is quite normal
        #  #else
        #  #  raise e
        #  #end
        #  p "goatchas"
        #end
        
      end
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      p "connection refused" # Connection expires on its own
      result=false
    rescue Timeout::Error, StandardError => e
      # This will happen when connection is imposible during the timeout period
      p "connection:  #{e}"   # When host or port is wrong   #THIS means connection timesout
      result=false
    rescue
    end
    return result
  end

end
