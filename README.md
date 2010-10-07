# ffi-hunspell

* [github.com/postmodern/ffi-hunspell](http://github.com/postmodern/ffi-hunspell)
* [github.com/postmodern/ffi-hunspell/issues](http://github.com/postmodern/ffi-hunspell/issues)
* Postmodern (postmodern.mod3 at gmail.com)

## Description

Ruby FFI bindings for [Hunspell](http://hunspell.sourceforge.net/).

## Examples

Open a dictionary:

    require 'ffi/hunspell'
    
    dict = FFI::Hunspell.dict('/usr/share/myspell/en_US')
    # ...
    dict.close

    FFI::Hunspell.dict('/usr/share/myspell/en_US') do |dict|
      # ...
    end

Check if a word is valid:

    dict.check?('dog')
    # => true

    dict.check?('d0g')
    # => false

Find the stems of a word:

    dict.stem('dogs')
    # => ["dog"]

## Requirements

* [libhunspell](http://hunspell.sourceforge.net/) >= 1.2.0
* [ffi](http://github.com/ffi/ffi) ~> 0.6.0

## Install

    $ sudo gem install ffi-hunspell

## License

See {file:LICENSE.txt} for license information.

