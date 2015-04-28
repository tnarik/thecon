require "thecon/version"

require 'timeout'
require 'socket'

require 'logger'

module Thecon
  # Your code goes here...
  def self.ready?(port=80, ip = "localhost", connection_timeout = 3, read_timeout = 2)
    @log = Logger.new(STDOUT)

    port ||= 80
    result = false
    begin
      timeout( connection_timeout ) do
        socket = Socket.new :INET, :STREAM
        sockaddr = Socket.pack_sockaddr_in port, ip
        socket.connect sockaddr
        begin
          timeout( read_timeout ) do
            begin

            response = socket.read_nonblock(1)

            r,w,e = select([socket], nil, nil, 1) # nil, nil, nil from inside the network
            result = true
            rescue IO::WaitReadable
              @log.debug "Wait readable"
              r,w,e = select([socket], nil, nil, 1) # nil, nil, nil from inside the network
              unless r.nil? then
                if r[0].read(1).nil?
                  @log.debug "Readable socket was closed / there is NOTHING there"
                  result = false
                else
                  @log.debug "There is something there" 
                  result = true
                end
              else
                @log.debug "not available for read: either doesn't exist or not closed" #TRUE
                result = true
              end
            rescue IO::WaitWritable
            end

          end
        rescue StandardError => ka #This can get triggered i
          @log.debug "OK, standardERROR #{ka}" #If socket.read there could be errors (this shouldn't be triggered)
          result = true
        rescue Timeout::Error => e
          @log.debug "timedout reading" #Socket is there but there are not data to read (if socket.read)
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
