
module Memria::Command
  def self.stats(socket, addr)
    items = {} of String => String
    send(socket, "stats\r\n").each do |line|
      stat, key, value = line.split(' ')
      items[key] = value
    end
    output(items, addr)
  end
  
  def self.settings(socket, addr)
    items = {} of String => String
    send(socket, "stats settings\r\n").each do |line|
      _, key, value = line.split(' ')
      items[key] = value
    end
    output(items, addr)
  end
  
  def self.sizes(socket, addr)
    items = {} of String => String
    send(socket, "stats sizes\r\n").each do |line|
      stat, key, value = line.split(' ')
      items[key] = value
    end
    output(items, addr)
  end
  
  def self.send(socket, command): Array(String)
    items = [] of String?
    socket << command
    loop do
      response = socket.gets
      return items.compact if response == "END"
      items << response
    end
  end
  
  def self.output(items, addr)
    printf "#%-17s %10s %14s\n", addr, "Field", "Value"
    items.keys.sort.each do |key|
      printf "%29s %14s\n", key, items[key]
    end
  end
end