# ffi-hunspell

* [Source](https://github.com/postmodern/ffi-hunspell)
* [Issues](https://github.com/postmodern/ffi-hunspell/issues)
* [Documentation](http://rubydoc.info/gems/ffi-hunspell/frames)
* [Email](postmodern.mod3 at gmail.com)

[![Build Status](https://secure.travis-ci.org/postmodern/ffi-hunspell.png?branch=master)](https://travis-ci.org/postmodern/ffi-hunspell)

## Description

Ruby FFI bindings for [Hunspell][libhunspell].

## Examples

Open a dictionary:

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

Check if a word is valid:

    dict.check?('dog')
    # => true

    dict.check?('d0g')
    # => false

Find the stems of a word:

    dict.stem('dogs')
    # => ["dog"]

Suggest alternate spellings for a word:

    dict.suggest('arbitrage')
    # => ["arbitrage", "arbitrages", "arbitrager", "arbitraged", "arbitrate"]

## Requirements

* [libhunspell] >= 1.2.0
* [ffi] ~> 1.0

## Install

    $ gem install ffi-hunspell
    
* Download dictionaries (you can find some on the [OpenOffice Archive](http://archive.services.openoffice.org/pub/mirror/OpenOffice.org/contrib/dictionaries))
* (Unzip them and) copy files with `.aff` and `.dic` into one of [these directories](lib/ffi/hunspell/hunspell.rb#L65-82)

## License

Copyright (c) 2010-2013 Hal Brodigan

See {file:LICENSE.txt} for license information.

[libhunspell]: http://hunspell.sourceforge.net/
[ffi]: https://github.com/ffi/ffi
