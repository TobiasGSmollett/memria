require "socket"
require "./command/*"

include Memria::Command

module Memria::CLI
  
  def self.run()
    if ARGV.empty?
      puts Memria::Command.help
    else
      host = ARGV[0].split(':')[0]
      port = ARGV[0].split(':')[1]? || 11211
      mode = ARGV[1]?
      self.exec_command(host, port, mode)
    end
  end
  
  def self.exec_command(host, port = 11211, mode = nil)
    addr = "#{host}:#{port}"
    socket = TCPSocket.new(host, port)
    case mode
    when nil, "display" 
      Command.display(socket)
    when "dump"
      Command.dump(socket)
    when "stats"
      Command.stats(socket, addr)
    when "settings"
      Command.settings(socket, addr)
    when "sizes"
      Command.sizes(socket, addr)
    else
      puts Command.help
    end
    socket.close
  end
end