require 'ffi'

module FFI
  module Hunspell
    extend FFI::Library

    ffi_lib 'hunspell-1.2'

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

    #
    # The directories to search for dictionary files.
    #
    # @return [Array]
    #   The directory paths.
    #
    # @since 0.2.0
    #
    def Hunspell.directories
      @directories ||= [
        '/usr/local/share/myspell',
        '/usr/share/myspell'
      ]
    end

    # prepend the ~/.hunspell_default directory to DIRS
    if (home = (ENV['HOME'] || ENV['HOMEPATH']))
      directories.unshift(File.join(home,'.hunspell_default'))
    end

    #
    # Opens a Hunspell dictionary.
    #
    # @param [String] path
    #   The path prefix shared by the `.aff` and `.dic` files.
    #
    # @yield [dict]
    #   The given block will be passed the Hunspell dictionary.
    #
    # @yieldparam [Dictionary] dict
    #   The opened dictionary.
    #
    # @return [nil]
    #
    def Hunspell.dict(path,&block)
      Dictionary.open(path,&block)
    end
  end
end
