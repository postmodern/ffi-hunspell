# ffi-hunspell

[![CI](https://github.com/postmodern/ffi-hunspell/actions/workflows/ruby.yml/badge.svg)](https://github.com/postmodern/ffi-hunspell/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/postmodern/ffi-hunspell.svg)](https://codeclimate.com/github/postmodern/ffi-hunspell)

* [Source](https://github.com/postmodern/ffi-hunspell)
* [Issues](https://github.com/postmodern/ffi-hunspell/issues)
* [Documentation](http://rubydoc.info/gems/ffi-hunspell/frames)

## Description

Ruby FFI bindings for [Hunspell][libhunspell].

## Examples

Open a dictionary:

```rb
require 'ffi/hunspell'
    
FFI::Hunspell.dict do |dict|
  # ...
end

FFI::Hunspell.dict('en_GB') do |dict|
  # ...
end

dict = FFI::Hunspell.dict('en_GB')
# ...
dict.close
```

Check if a word is valid:

```rb
dict.check?('dog')
# => true

dict.check?('d0g')
# => false
```

Find the stems of a word:

```rb
dict.stem('dogs')
# => ["dog"]
```

Suggest alternate spellings for a word:

```rb
dict.suggest('arbitrage')
# => ["arbitrage", "arbitrages", "arbitrager", "arbitraged", "arbitrate"]
```

## Requirements

* [libhunspell] >= 1.2.0, <= 1.7.0
* [ffi] ~> 1.0

## Install

```sh
$ gem install ffi-hunspell
```

### libhunspell

* Debian / Ubuntu:

      $ sudo apt install libhunspell-dev hunspell-en-us

* RedHat / Fedora:

      $ sudo dnf install hunspell-devel hunspell-en

* macOS:

      $ brew install hunspell

## License

Copyright (c) 2010-2021 Hal Brodigan

See {file:LICENSE.txt} for license information.

[libhunspell]: http://hunspell.github.io/
[ffi]: https://github.com/ffi/ffi#readme
