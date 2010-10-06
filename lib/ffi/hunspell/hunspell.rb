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
  end
end
