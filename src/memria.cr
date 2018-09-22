require "regex"
require "socket"

module Memria
  VERSION = "0.1.0"

  def self.run(host, port, mode = nil)
    socket = TCPSocket.new(host, port, mode)
    memria = Memria.new(host, port)
    case mode
    when nil, "display" 
      memria.display(socket)
    when "dump"
      memria.dump(socket)
    when "stats"
      memria.stats(socket)
    when "settings"
      memria.settings(socket)
    when "sizes"
      memria.sizes(socket)
    else
      help
    end
    socket.close
  end

  def self.help
    "Usage: memria <host[:port] | /path/to/socket> [mode]\n" +
    "   memria 10.0.0.5:11211 display        # shows slabs\n" +
    "   memria 10.0.0.5:11211                # same.  (default is display)\n" +
    "   memria 10.0.0.5:11211 stats          # shows general stats\n" +
    "   memria 10.0.0.5:11211 settings       # shows settings stats\n" +
    "   memria 10.0.0.5:11211 sizes          # shows sizes stats\n" +
    "   memria 10.0.0.5:11211 dump [limit]   # dumps keys and values\n" +
    "WARNING! sizes is a development command.\n" +
    "As of 1.4 it is still the only command which will lock your memcached instance for some time. " +
    "If you have many millions of stored items, it can become unresponsive for several minutes. " +
    "Run this at your own risk. It is roadmapped to either make this feature optional " +
    "or at least speed it up.\n"
  end

  class Memria
    getter host : String, port : Int32, addr : String
    
    def initialize(@host, @port)
      @addr = @host + ":" + @port.to_s
    end

    def display(socket)
      items = {} of String => Hash(String, String)
      max_slab_number = 0
      send(socket, "stats items\r\n").each do |line|
        puts line
        _, _, slabclass, stat, value = line.split(/:| /)
        items[slabclass] = {} of String => String if !items.has_key? slabclass
        items[slabclass][stat] = value
      end
      send(socket, "stats slabs\r\n").each do |line| 
        puts line
        next if !line.match(/^STAT (\d+):(\w+) (\d+)/)
        _, file_descriptor, stat, value = line.split(/:| /)
        items[file_descriptor] = {} of String => String if !items.has_key? file_descriptor
        items[file_descriptor][stat] = value
        max_slab_number = file_descriptor.to_i
      end
      
      puts "  #  Item_Size  Max_age   Pages   Count   Full?  Evicted Evict_Time OOM\n"
      (1..max_slab_number).each do |i|
        item = items[i.to_s]
        next if item["total_pages"] == "0"
        size = 
          if item["chunk_size"].to_i < 1024 
            item["chunk_size"] + "B"
          else
            sprintf("%.1fK", item["chunk_size"].to_i / 1024.0)
          end
        full = 
          if item["used_chunks"] == item["total_chunks"]
            "yes"
          else 
            "no" 
          end
        printf("%3d %8s %9ds %7d %7d %7s %8d %8d %4d\n",
          i, size, item["age"], item["total_pages"],
          item["number"], full, item["evicted"],
          item["evicted_time"], item["outofmemory"])
      end      
    end

    def dump(socket)
      socket << "lru_crawler metadump all\r\n";
      keyexp = {} of String => Int32
      loop do
        line = socket.gets
        break if line == "END"
        if line && line.match(/^key=(\S+) exp=(-?\d+) .*/)
          _, key, _, exp = line.split(/=| /)
          if exp.to_i == -1
            keyexp[key] = 0
          else
            keyexp[key] = exp.to_i
          end
        end
      end
      keyexp.keys.each do |key|
        socket << "get #{key}\r\n"
        line = socket.gets
        # VALUE <key> <flags> <bytes> [<cas unique>]\r\n
        # <data block>\r\n
        if line && line.match(/VALUE (\S+) (\d+) (\d+)/)
          _, _, flags, len = line.split(' ')
          val = socket.gets
          print "add #{key} #{flags} #{keyexp[key]} #{len}\r\n#{val}\r\n"
          # get the END
          socket.gets
        end
      end
    end

    def stats(socket)
      items = {} of String => String
      send(socket, "stats\r\n").each do |line|
        stat, key, value = line.split(' ')
        items[key] = value
      end
      output(items)
    end

    def settings(socket)
      items = {} of String => String
      send(socket, "stats settings\r\n").each do |line|
        _, key, value = line.split(' ')
        items[key] = value
      end
      output(items)
    end

    def sizes(socket)
      items = {} of String => String
      send(socket, "stats sizes\r\n").each do |line|
        stat, key, value = line.split(' ')
        items[key] = value
      end
      output(items)
    end
  
    def send(socket, command): Array(String)
      items = [] of String?
      socket << command
      loop do
        response = socket.gets
        return items.compact if response == "END"
        items << response
      end
    end
    
    def output(items)
      printf "#%-17s %10s %12s\n", @addr, "Field", "Value"
      items.keys.sort.each do |key|
        printf "%29s %12s\n", key, items[key]
      end
    end
  end
end

#Memria.run(mode)