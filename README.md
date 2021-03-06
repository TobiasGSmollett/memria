# memria

Memria is  [memcached-tool](https://github.com/memcached/memcached/blob/master/scripts/memcached-tool) for Crystal.

## Installation

```sh
$ git clone https://github.com/TobiasGSmollett/memria.git
$ cd memria
$ make
$ make install
```

## Required

- `Crystal v0.26.1`

## Usage

```sh
$ memria localhost help
Usage: memria host[:port] [mode]
   memria 10.0.0.5:11211 display        # shows slabs
   memria 10.0.0.5:11211                # same.  (default is display)
   memria 10.0.0.5:11211 stats          # shows general stats
   memria 10.0.0.5:11211 settings       # shows settings stats
   memria 10.0.0.5:11211 sizes          # shows sizes stats
   memria 10.0.0.5:11211 dump           # dumps keys and values
   ...

$ memria localhost dump
add foo 0 0 2
11

$ memria localhost stats
#localhost:11211        Field          Value
              accepting_conns              1
                    auth_cmds              0
                  auth_errors              0
                        bytes             64
                   bytes_read           4837
                bytes_written         346499
                          ...            ...
```
## Development

- Error handling

## Contributing

1. Fork it (<https://github.com/TobiasGSmollett/memria/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [TobiasGSmollett](https://github.com/TobiasGSmollett) TobiasGSmollett - creator, maintainer
