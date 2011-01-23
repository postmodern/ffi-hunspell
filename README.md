# ffi-hunspell

* [Source](http://github.com/postmodern/ffi-hunspell)
* [Issues](http://github.com/postmodern/ffi-hunspell/issues)
* [Documentation](http://rubydoc.info/gems/ffi-hunspell)
* Postmodern (postmodern.mod3 at gmail.com)

## Description

Ruby FFI bindings for [Hunspell](http://hunspell.sourceforge.net/).

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

* [libhunspell](http://hunspell.sourceforge.net/) >= 1.2.0
* [ffi](http://github.com/ffi/ffi) ~> 0.6.0
* [env](http://github.com/postmodern/env) ~> 0.1.2

## Install

    $ sudo gem install ffi-hunspell

## Known Issues

Some Linux distributions do not install the `libhunspell-1.2.so`
shared library file, but instead installs `libhunspell-1.2.so.0`.
Simply create a symbolic link to the hunspell shared library,
so that {FFI::Hunspell} can find the library:

    # ln -s /usr/lib/libhunspell-1.2.so.0 /usr/lib/libhunspell-1.2.so

## License

See {file:LICENSE.txt} for license information.

