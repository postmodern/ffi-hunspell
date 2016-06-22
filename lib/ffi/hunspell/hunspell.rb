require 'ffi'

module FFI
  module Hunspell
    extend FFI::Library

    ffi_lib [
      'hunspell-1.4', 'libhunspell-1.4.so.0',
      'hunspell-1.3', 'libhunspell-1.3.so.0',
      'hunspell-1.2', 'libhunspell-1.2.so.0'
    ]


    attach_function :Hunspell_create, [:string, :string], :pointer
    attach_function :Hunspell_create_key, [:string, :string, :string], :pointer
    attach_function :Hunspell_destroy, [:pointer], :void
    attach_function :Hunspell_spell, [:pointer, :string], :int
    attach_function :Hunspell_get_dic_encoding, [:pointer], :string
    attach_function :Hunspell_suggest, [:pointer, :pointer, :string], :int
    attach_function :Hunspell_analyze, [:pointer, :pointer, :string], :int
    attach_function :Hunspell_stem, [:pointer, :pointer, :string], :int
    attach_function :Hunspell_generate, [:pointer, :pointer, :string, :string], :int
    attach_function :Hunspell_add, [:pointer, :string], :int
    attach_function :Hunspell_add_with_affix, [:pointer, :string, :string], :int
    attach_function :Hunspell_remove, [:pointer, :string], :int
    attach_function :Hunspell_free_list, [:pointer, :pointer, :int], :void

    #
    # missing functions:
    #
    #   attach_function :Hunspell_stem2, [:pointer, :pointer, :pointer, :int], :int
    #   attach_function :Hunspell_generate2, [:pointer, :pointer, :string, :pointer, :int], :int
    #

    # The language to default to, if no 'LANG' env variable was set.
    DEFAULT_LANG = ENV.fetch('LANG','en_US.UTF-8').split('.',2).first

    #
    # The default language.
    #
    # @return [String]
    #   The name of the default language.
    #
    # @since 0.2.0
    #
    def self.lang
      @lang ||= DEFAULT_LANG
    end

    #
    # Sets the default language.
    #
    # @param [String] new_lang
    #   The new language name.
    #
    # @return [String]
    #   The name of the new default language.
    #
    # @since 0.2.0
    #
    def self.lang=(new_lang)
      @lang = new_lang.to_s
    end

    # The directory name used to store user installed dictionaries.
    USER_DIR = '.hunspell_default'

    # Known directories to search within for dictionaries.
    KNOWN_DIRECTORIES = [
      # User
      File.join(Gem.user_home,USER_DIR),
      # OS X brew-instlled hunspell
      File.join(Gem.user_home,'Library/Spelling'),
      '/Library/Spelling',
      # Debian
      '/usr/local/share/myspell/dicts',
      '/usr/share/myspell/dicts',
      # Ubuntu
      '/usr/share/hunspell',
      # Fedora
      '/usr/local/share/myspell',
      '/usr/share/myspell',
      # Mac Ports
      '/opt/local/share/hunspell',
      '/opt/share/hunspell'
    ]

    #
    # The dictionary directories to search for dictionary files.
    #
    # @return [Array<String, Pathname>]
    #   The directory paths.
    #
    # @since 0.2.0
    #
    def self.directories
      @directories ||= KNOWN_DIRECTORIES.select do |path|
        File.directory?(path)
      end
    end

    def self.directories=(dirs)
      @directories = dirs
    end

    #
    # Opens a Hunspell dictionary.
    #
    # @param [Symbol, String] name
    #   The name of the dictionary to open.
    #
    # @yield [dict]
    #   The given block will be passed the Hunspell dictionary.
    #
    # @yieldparam [Dictionary] dict
    #   The opened dictionary.
    #
    # @return [nil]
    #
    def self.dict(name=Hunspell.lang,&block)
      Dictionary.open(name,&block)
    end
  end
end
