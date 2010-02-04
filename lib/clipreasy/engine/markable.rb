module CliPrEasy
  module Engine
    
    #
    # Allows any object to be markable with user-data.
    #
    # This module is expected to be included by classes that want to implement the
    # Markable design pattern.
    #
    # == Detailed API
    module Markable
      
      # Returns true if a mark is known, false otherwise. A mark is considered known
      # if the key exists in the underlying Hash, even if the associated value is nil!
      def has_mark?(key)
        @marks && @marks.has_key?(key)
      end
      
      # Returns user-value associated to _key_, nil if no such key in user-data.
      def get_mark(key)
        @marks && @marks[key] 
      end
      alias :[] :get_mark
  
      # Associates _value_ to _key_ in user-data. Overrides previous value if 
      # present.
      def set_mark(key,value)
        @marks = Hash.new unless @marks
        @marks[key] = value
      end
      alias :[]= :set_mark
  
      # Removes a mark denoted by its key.
      def remove_mark(key)
        @marks && @marks.delete(key)
      end

      # Extracts the copy of attributes which can subsequently be modified.
      def marks
        @marks.nil? ? {} : @marks.dup
      end

    end # module Markable
    
  end # module Engine
end # module CliPrEasy