module CliPrEasy
  module State
    #
    # Encapsulates a database transaction
    #
    class Transaction
      
      # Creates a transaction instance with a given connection
      def initialize(db, conn)
        @db, @conn = db, conn
      end
      
      # Returns datasets under names
      def method_missing(name, *args, &block)
        if name.to_s =~ /^[a-z_]+$/
          @db[name]
        else
          super(name, *args, &block)
        end
      end
      
    end # class Transaction
  end # module State
end # module CliPrEasy