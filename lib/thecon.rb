require "thecon/version"

require 'timeout'
require 'socket'

module Thecon
  # Your code goes here...
  def self.ready?(port=80, ip = "localhost", connection_timeout = 3, read_timeout = 2)
  	result = false
		begin
  		timeout( connection_timeout ) do
        socket = Socket.new :INET, :STREAM
        sockaddr = Socket.pack_sockaddr_in port, ip
        socket.connect sockaddr
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
          end
        rescue StandardError => ka
          p "OK, standardERROR #{ka}" #If socket.read there could be errors (this shouldn't be triggered)
          result = true
        rescue Timeout::Error => e
          p "timedout reading" #Socket is there but there are not data to read (if socket.read)
          result = true
        end
      end
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      result=false # Connection fails on its own
    rescue Timeout::Error, StandardError => e
      result=false # When host or port is wrong (connection timesout or some other Errno)
    rescue
    end

    result
  end

end
