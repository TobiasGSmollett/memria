require "./memria/cli"

include Memria::CLI

module Memria
  VERSION = "0.1.0"
end

Memria::CLI.run