require 'ffi/hunspell/hunspell'

module FFI
  module Hunspell
    #
    # Represents a dictionary for a specific language.
    #
    class Dictionary

      # The affix file extension
      AFF_EXT = 'aff'

      # The dictionary file extension
      DIC_EXT = 'dic'

      #
      # Creates a new dictionary.
      #
      # @param [String] affix_path
      #   The path to the `.aff` file.
      #
      # @param [String] dic_path
      #   The path to the `.dic` file.
      #
      # @param [String] key
      #   The optional key for encrypted dictionary files.
      #
      # @raise [RuntimeError]
      #   Either the `.aff` or `.dic` files did not exist.
      #
      def initialize(affix_path,dic_path,key=nil)
        unless File.file?(affix_path)
          raise("invalid affix path #{affix_path.inspect}")
        end

        unless File.file?(dic_path)
          raise("invalid dic path #{dic_path.inspect}")
        end

        @ptr = if key then Hunspell.Hunspell_create_key(affix_path,dic_path,key)
               else        Hunspell.Hunspell_create(affix_path,dic_path)
               end
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
      # @return [Dictionary]
      #   If no block is given, the open dictionary will be returned.
      #
      # @raise [ArgumentError]
      #   The dictionary files could not be found in any of the directories.
      #
      def self.open(name)
        name = name.to_s

        Hunspell.directories.each do |dir|
          affix_path = File.join(dir,"#{name}.#{AFF_EXT}")
          dic_path   = File.join(dir,"#{name}.#{DIC_EXT}")

          if (File.file?(affix_path) && File.file?(dic_path))
            dict = self.new(affix_path,dic_path)

            if block_given?
              yield dict

              dict.close
              return nil
            else
              return dict
            end
          end
        end

        raise(ArgumentError,"unable to find the dictionary #{name.dump} in any of the directories")
      end

      #
      # Determines if the dictionary is closed.
      #
      # @return [Boolean]
      #   Specifies whether the dictionary was closed.
      #
      def closed?
        @ptr.nil?
      end

      #
      # The encoding of the dictionary file.
      #
      # @return [Encoding]
      #   The encoding of the dictionary file.
      #
      def encoding
        @encoding ||= Encoding.const_get(
          Hunspell.Hunspell_get_dic_encoding(self).gsub('-','_')
        )
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

      alias << add

      def add_affix(word,example)
        Hunspell.Hunspell_add_affix(self,word.to_s,example.to_s)
      end

      #
      # Load an extra dictionary file. The extra dictionaries use the
      # affix file of the allocated Hunspell object.
      #
      # Maximal number of extra dictionaries is limited in the source code (20)
      #
      # @param [String] dic_path
      #   The path to the extra `.dic` file.
      #
      # @raise [RuntimeError]
      #   The extra `.dic` file did not exist.
      #
      #
      def add_dic(dic_path)
        unless File.file?(dic_path)
          raise("invalid extra dictionary path #{dic_path.inspect}")
        end

        Hunspell.Hunspell_add_dic(self,dic_path)
      end

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
          ptr   = output.get_pointer(0)

          if count > 0
            stems = ptr.get_array_of_string(0,count)
          end
        end

        return stems.map { |word| force_encoding(word) }
      end

      #
      # Suggests alternate spellings of a word.
      #
      # @param [String] word
      #   The word in question.
      #
      # @return [Array<String>]
      #   The suggestions for the word.
      #
      def suggest(word)
        suggestions = []

        FFI::MemoryPointer.new(:pointer) do |output|
          count = Hunspell.Hunspell_suggest(self,output,word.to_s)
          ptr   = output.get_pointer(0)

          if count > 0
            suggestions = ptr.get_array_of_string(0,count)
          end
        end

        return suggestions.map { |word| force_encoding(word) }
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

      protected

      #
      # Encodes a String into the dictionary's encoding.
      #
      # @param [String] string
      #   The unencoded String.
      #
      # @return [String]
      #   The encoded String.
      #
      def force_encoding(string)
        string.force_encoding(encoding)
      end

    end
  end
end
