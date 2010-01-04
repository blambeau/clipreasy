module CliPrEasy
  module State
    #
    # Decorates a Hash with useful relational tuple operators
    #
    class Tuple
      
      # Creates a tuple instance with a given hash
      def initialize(decorated)
        @decorated = decorated
        decorated.each_key do |key|
          raise ArgumentError, "Invalid tuple attribute #{key}" unless Symbol===key
          self.instance_eval <<-EOF
            def #{key}
              @decorated[:"#{key}"]
            end
            def #{key}=(val)
              @decorated[:"#{key}"] = val
            end
          EOF
        end
      end
      
    end # class Tuple
  end # module State
end # module CliPrEasy