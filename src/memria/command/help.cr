module Memria::Command
  def self.help
    "Usage: memria host[:port] [mode]\n" +
    "   memria 10.0.0.5:11211 display        # shows slabs\n" +
    "   memria 10.0.0.5:11211                # same.  (default is display)\n" +
    "   memria 10.0.0.5:11211 stats          # shows general stats\n" +
    "   memria 10.0.0.5:11211 settings       # shows settings stats\n" +
    "   memria 10.0.0.5:11211 sizes          # shows sizes stats\n" +
    "   memria 10.0.0.5:11211 dump           # dumps keys and values\n" +
    "WARNING! sizes is a development command.\n" +
    "As of 1.4 it is still the only command which will lock your memcached instance for some time. " +
    "If you have many millions of stored items, it can become unresponsive for several minutes. " +
    "Run this at your own risk. It is roadmapped to either make this feature optional " +
    "or at least speed it up.\n"
  end
end