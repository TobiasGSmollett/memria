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

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/TobiasGSmollett/memria/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [TobiasGSmollett](https://github.com/TobiasGSmollett) TobiasGSmollett - creator, maintainer
