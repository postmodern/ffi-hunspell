### 0.2.2 / 2011-01-25

* Added {FFI::Hunspell::USER_DIR}.
* Added {FFI::Hunspell::KNOWN_DIRECTORIES}, containing known dictionary
  directories used by Debian, Fedora and Mac Ports.
* Have {FFI::Hunspell.directories} return the dictionary directories found
  on the system.

### 0.2.1 / 2011-01-23

* Require env ~> 0.1.2.
  * Use `Env.lang` to get the default language.
* Updated the Copyright years.

### 0.2.0 / 2011-01-22

* Added {FFI::Hunspell.lang}.
* Added {FFI::Hunspell.lang=}.
* Added {FFI::Hunspell.directories}.
* Have {FFI::Hunspell::Dictionary.open} accept a language name, and search
  {FFI::Hunspell.directories} for the dictionary files.

### 0.1.0 / 2010-10-05

* Initial release.

