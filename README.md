ZQ - Unixy building blocks in ruby  
========
[![Build Status](https://travis-ci.org/kairichard/zq.png?branch=master)](https://travis-ci.org/kairichard/zq) [![Gem Version](https://badge.fury.io/rb/zq.png)](https://badge.fury.io/rb/zq) [![Dependency Status](https://gemnasium.com/kairichard/zq.svg)](https://gemnasium.com/kairichard/zq)


This started as a simple proof of concept and looked kinda promising.
The hole concept is centered around an Orchestra which has a `source` where it can
read chunks of data from. The data is than passed through chainable `composers`.
The source and the composers just need to implement a certain method each in order to work.

#### Examples-Orchestras
This is how the Echo-Orchestra looks like
```ruby
class Echo
  include ZQ::Orchestra
  source ZQ::Sources::IOSource.new $stdin
  compose_with ZQ::Composer::Echo.new
  desc 'prints contents from stdin'
end
```
Thats fairly verbose to just implement a `PIPE`. But consider the following
```ruby
equire 'redis'
require 'zq'

CLIENT = Redis.new(db: 1)

class RedisPull
  include ZQ::Orchestra
  source ZQ::Sources::RedisLPOP.new(CLIENT, "incoming")
  compose_with ZQ::Composer::Echo.new
  desc "reads from redis:key:'incoming' and prints to stdout"
end
```
Here we print items from a redis list. Checkout the examples directory for more.
Also check the lib/source and lib/composers directory and mix and match your tool

###### Synopsis
```bash
zq <cmd> <ORCHESTRA_NAME> [--file=<FILE>]
# or
Commands:
  zq help [COMMAND]       # Describe available commands or one specific command
  zq list                 # List available orchestras.
  zq play ORCHESTRA_NAME  # Start orchestrating.

Options:
  -r, [--file=FILE]  # Require file to load orchestras from
---

Usage:
  zq play ORCHESTRA_NAME

Options:
  -d, [--forever], [--no-forever]  # Keep running even if source is exhausted
  -i, [--interval=N]               # Play orchestra every N seconds
                                   # Default: 0
  -r, [--file=FILE]                # Require file to load orchestras from

Start orchestrating.
```
Installing
-------------
Lace comes as a gem, so given you have ruby installed simply do the following
```bash
> gem install zq
```

## Contributing Code

If you want to contribute code, please try to:

* Follow the same coding style as used in the project. Pay attention to the
  usage of tabs, spaces, newlines and brackets. Try to copy the aesthetics the
  best you can.
* Add a scenario under `features` that verifies your change (test with `rake features`). Look at the existing test
  suite to get an idea for the kind of tests I like. If you do not provide a
  test, explain why.
* Write [good commit messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html),
  explain what your patch does, and why it is needed.
* Keep it simple: Any patch that changes a lot of code or is difficult to
  understand should be discussed before you put in the effort.

Once you have tried the above, create a GitHub pull request to notify me of your
changes.

##TODO
  * add more sources and composers
  * transactional composing
