require 'ffi/hunspell/hunspell'

module FFI
  module Hunspell
    class Dictionary

      def initialize(affix_path,dict_path,key=nil)
        @ptr = if key
                 Hunspell.Hunspell_create_key(affix_path,dict_path,key)
               else
                 Hunspell.Hunspell_create(affix_path,dict_path)
               end
      end

      def self.open(path)
        dict = self.new("#{path}.aff","#{path}.dic")

        if block_given?
          yield dict

          dict.destroy
          return nil
        else
          return dict
        end
      end

      def encoding
        Hunspell.Hunspell_get_dic_encoding(self)
      end

      def add(word)
        Hunspell.Hunspell_add(self,word.to_s)
      end

      def add_affix(word,example)
        Hunspell.Hunspell_add_affix(self,word.to_s,example.to_s)
      end

      alias << add

      def remove(word)
        Hunspell.Hunspell_remove(self,word.to_s)
      end

      alias delete remove

      def check(word)
        Hunspell.Hunspell_spell(self,word.to_s) != 0
      end

      def stem(word)
        stem_ptr = FFI::MemoryPointer.new(:pointer)
        count = Hunspell.Hunspell_stem(self,stem_ptr,word.to_s)
        stem_ptr = stem_ptr.get_pointer(0)

        return (0...count).map do |i|
          stem_ptr.get_pointer(i).get_string(0)
        end
      end

      def suggest(word)
        suggestion_ptr = FFI::MemoryPointer.new(:pointer)
        count = Hunspell.Hunspell_suggest(self,suggestion_ptr,word.to_s)
        suggestion_ptr = suggestion_ptr.get_pointer(0)

        return (0...count).map do |i|
          suggestion_ptr.get_pointer(i).get_string(0)
        end
      end

      def destroy
        Hunspell.Hunspell_destroy(self)
      end

      def to_ptr
        @ptr
      end

    end
  end
end
