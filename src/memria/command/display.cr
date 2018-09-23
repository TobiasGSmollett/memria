
module Memria::Command
  def self.display(socket)
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
end