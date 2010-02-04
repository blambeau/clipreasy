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
  
      # Returns user-value associated to _key_, nil if no such key in user-data.
      def [](key) @data[key] end
  
      # Associates _value_ to _key_ in user-data. Overrides previous value if 
      # present.
      def []=(key,value)
        @data[key] = value
      end
  
      # Removes a mark
      def remove_mark(key)
        @data.delete(key)
      end

      # Extracts the copy of attributes which can subsequently be modified.
      def data
        @data.nil? ? {} : @data.dup
      end

    end # module Markable
    
  end # module Engine
end # module CliPrEasy