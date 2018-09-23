
module Memria::Command
  def self.dump(socket)
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
end