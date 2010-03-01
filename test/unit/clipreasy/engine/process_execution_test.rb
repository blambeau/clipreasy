require 'clipreasy'
require 'clipreasy/clipreasy_test'
module CliPrEasy
  module Engine
    class ProcessExecutionTest < CliPrEasy::CliPrEasyTest
      
      class Backend
        
        def initialize(process)
          @process = process
          @next_id = 1
          @relation = {0 => {:id => 0, :parent => nil, :statement_token => 0, :status => :pending}}
        end
        
        # Branches attributes
        def branch(attributes, who, *args)
          new_id, @next_id = @next_id, @next_id+1
          @relation[new_id] = { :id => new_id, 
                                :parent => attributes[:id], 
                                :statement_token => who.statement_token,
                                :status => :pending } 
          # puts "New branch now (#{new_id}) ------------------------ "
          # puts self.inspect
          @relation[new_id]
        end

        def ended?(attributes)
          attributes[:status] == :ended
        end
        
        def pending?(attributes)
          attributes[:status] == :pending
        end
        
        def close(attributes, statement)
#          puts "Closing #{attributes.inspect}"
          attributes[:status] = :ended          
        end
        
        def parent_of(attributes)
          @relation[attributes[:parent]]
        end
        
        def children_of(attributes)
          @relation.values.select{|attrs| attrs[:parent] == attributes[:id]}
        end
        
        def all_closed?
          @relation.values.all?{|v| self.ended?(v)}
        end
        
        def inspect
          buffer = "[\n"
          @relation.values.sort{|v1,v2| v1[:id] <=> v2[:id]}.each do |val|
            values = val.merge(:statement => @process.statement(val[:statement_token]).inspect)
            buffer << "  #{values.inspect}\n"
          end
          buffer << "]\n"
          buffer
        end
        
        def evaluate(attributes, expression)
          case expression
            when "true"
              true
            when "false"
              false
            when "too_much?"
              false
            else
              raise "Unexpected expression #{expression}"
          end
        end
        
      end
      
      def relative_file(path)
        File.join(File.dirname(__FILE__), path)
      end
      
      def test_with_backend_on_example1
        process = ProcessXMLDecoder.decode_file(relative_file('example_1.cpe'))
        backend = Backend.new(process)
        context = BackendProcessContext.new(backend, process, 
          {:id => 0, :statement_token => 0, :status => :pending}
        )
        ctx = process.start(context)
        assert Array===ctx
        until ctx.empty?
          ctx = ctx.collect{|c| c.activity_ended}.flatten
          assert ctx.compact==ctx, "No nil inside context #{ctx.inspect}"
        end
        assert backend.all_closed?
      end
      
      def test_with_backend_on_example2
        process = ProcessXMLDecoder.decode_file(relative_file('example_2.cpe'))
        backend = Backend.new(process)
        context = BackendProcessContext.new(backend, process, 
          {:id => 0, :statement_token => 0, :status => :pending}
        )
        ctx = process.start(context)
        assert Array===ctx
        until ctx.empty?
          ctx = ctx.collect{|c| c.activity_ended}.flatten
          assert ctx.compact==ctx, "No nil inside context #{ctx.inspect}"
        end
        assert backend.all_closed?
        
        #puts backend.inspect
      end
      
    end # class ProcessExecutionTest
  end # module Engine
end # module CliPrEasy
      