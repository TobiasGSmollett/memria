# memria

Memria is  [memcached-tool](https://github.com/memcached/memcached/blob/master/scripts/memcached-tool) for Crystal.

## Installation

```sh
$ git clone 
$ cd memria/src
```

## Usage

```ruby
icr(0.26.1) > require "./memria" 
icr(0.26.1) > puts Memria.help

Usage: memria <host[:port] | /path/to/socket> [mode]
   memria 10.0.0.5:11211 display        # shows slabs
   memria 10.0.0.5:11211                # same.  (default is display)
   memria 10.0.0.5:11211 stats          # shows general stats
   memria 10.0.0.5:11211 settings       # shows settings stats
   memria 10.0.0.5:11211 sizes          # shows sizes stats
   memria 10.0.0.5:11211 dump [limit]   # dumps keys and values
WARNING! sizes is a development command.
As of 1.4 it is still the only command which will lock your memcached instance for some time. If you have many millions of stored items, it can become unresponsive for several minutes. Run this at your own risk. It is roadmapped to either make this feature optional or at least speed it up.

icr(0.26.1) > Memria.run("localhost", 11211, "dump")
add foo 0 0 2
11
```
## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/TobiasGSmollett/memria/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [TobiasGSmollett](https://github.com/TobiasGSmollett) TobiasGSmollett - creator, maintainer
