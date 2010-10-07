require 'ffi/hunspell/hunspell'

module FFI
  module Hunspell
    class Dictionary

      #
      # Creates a new dictionary.
      #
      # @param [String] affix_path
      #   The path to the `.aff` file.
      #
      # @param [String] dict_path
      #   The path to the `.dic` file.
      #
      # @param [String] key
      #   The optional key for encrypted dictionary files.
      #
      def initialize(affix_path,dic_path,key=nil)
        @ptr = if key
                 Hunspell.Hunspell_create_key(affix_path,dic_path,key)
               else
                 Hunspell.Hunspell_create(affix_path,dic_path)
               end
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
      # @return [Dictionary]
      #   If no block is given, the open dictionary will be returned.
      #
      def self.open(path)
        dict = self.new("#{path}.aff","#{path}.dic")

        if block_given?
          yield dict

          dict.close
          return nil
        else
          return dict
        end
      end

      #
      # The encoding of the dictionary file.
      #
      # @return [String]
      #   The encoding of the dictionary file.
      #
      def encoding
        Hunspell.Hunspell_get_dic_encoding(self)
      end

      #
      # Adds a word to the dictionary.
      #
      # @param [String] word
      #   The word to add to the dictionary.
      #
      def add(word)
        Hunspell.Hunspell_add(self,word.to_s)
      end

      def add_affix(word,example)
        Hunspell.Hunspell_add_affix(self,word.to_s,example.to_s)
      end

      alias << add

      #
      # Removes a word from the dictionary.
      #
      # @param [String] word
      #   The word to remove.
      #
      def remove(word)
        Hunspell.Hunspell_remove(self,word.to_s)
      end

      alias delete remove

      #
      # Checks if the word is validate.
      #
      # @param [String] word
      #   The word in question.
      #
      # @return [Boolean]
      #   Specifies whether the word is valid.
      #
      def check?(word)
        Hunspell.Hunspell_spell(self,word.to_s) != 0
      end

      alias valid? check?

      #
      # Finds the stems of a word.
      #
      # @param [String] word
      #   The word in question.
      #
      # @return [Array<String>]
      #   The stems of the word.
      #
      def stem(word)
        stems = []

        FFI::MemoryPointer.new(:pointer) do |output|
          count = Hunspell.Hunspell_stem(self,output,word.to_s)
          ptr = output.get_pointer(0)

          stems = ptr.get_array_of_string(0,count)
        end

        return stems
      end

      #
      # Suggests alternate spellings of a word.
      #
      # @param [String] word
      #   The word in question.
      #
      # @yield [suggested]
      #   If a block is given, it will be passed each suggested word.
      #
      # @yieldparam [String] suggested
      #   A suggested alternate spelling for the word.
      #
      # @return [Array<String>]
      #   The suggestions for the word.
      #
      def suggest(word)
        suggestions = []

        FFI::MemoryPointer.new(:pointer) do |output|
          count = Hunspell.Hunspell_suggest(self,output,word.to_s)
          ptr = output.get_pointer(0)

          ptr.get_array_of_pointer(0,count).each do |suggested_ptr|
            suggested = suggested_ptr.get_string(0)

            yield suggested if block_given?
            suggestions << suggested
          end
        end

        return suggestions
      end

      #
      # Closes the dictionary.
      #
      # @return [nil]
      #
      def close
        Hunspell.Hunspell_destroy(self)

        @ptr = nil
        return nil
      end

      #
      # Converts the dictionary to a pointer.
      #
      # @return [FFI::Pointer]
      #   The pointer for the dictionary.
      #
      def to_ptr
        @ptr
      end

    end
  end
end
