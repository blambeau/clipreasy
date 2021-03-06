require 'singleton'
module CliPrEasy
  module State
    #
    # Implements the Backend contract of the engine on top of the relational 
    # database.
    #
    class ProcessExecutionBackend < CliPrEasy::Engine::BackendProcessContext::Backend
      include Singleton
      
      # Delegates class calls to the singleton, in order to hide the singleton
      # pattern
      class << self
        def method_missing(name, *args, &block)
          self.instance.send(name, *args, &block)
        end
      end
    
      # Returns statement executions
      def process_executions
        CliPrEasy::DAS.dataset(:process_executions)
      end
      
      # Returns statement executions
      def statement_executions
        CliPrEasy::DAS.dataset(:statement_executions)
      end
      
      # Starts a process execution and returns an execution context instance
      def start_process(process, opts = {}, &block)
        process = CliPrEasy::Engine::Process[process] unless CliPrEasy::Engine::Process===process
        tuple = {:process => process.id, :status => 'pending'}.merge(opts)
        procexec_id = process_executions.insert(tuple)
        tuple = {
          :process            => process.id,
        	:process_execution  => procexec_id,
        	:statement          => process.statement_token,
          :status             => 'pending'
        }.merge(opts)
        statexec_id = statement_executions.insert(tuple)
        attributes = statement_executions.filter(:id => statexec_id).first
        context = CliPrEasy::Engine::BackendProcessContext.new(self, process, attributes)
        result = process.start(context)
        block.call(result) if block
        result
      end
      
      # Restores an execution context from an identifier
      def restore(id)
        attributes = statement_executions.filter(:id => id).first
        return nil unless attributes
        process = CliPrEasy::Engine::Process[attributes[:process]]
        raise IllegalStateError, "Corrupted database? No such process #{attributes[:process]}" unless process
        statement = process.statement(attributes[:statement])
        raise IllegalStateError, "Corrupted database? No such statement #{attributes[:statement]}" unless statement
        CliPrEasy::Engine::BackendProcessContext.new(self, statement, attributes)
      end
      
      # Retores an execution context and continue execution by firing
      # an activity ended message.
      def activity_ended(id, &block)
        result = restore(id).activity_ended
        block.call(result) if block
        result
      end
      
      # Checks if some attributes can be interpreted as a pending statement
      def pending?(attributes)
        attributes[:status] == 'pending'
      end
      
      # Checks if some attributes can be interpreted as an ended statement
      def ended?(attributes)
        attributes[:status] == 'ended'
      end
      
      # Returns the parent attributes of some attributes.
      def parent_of(attributes)
        statement_executions.filter(:id => attributes[:parent]).first
      end
      
      # Returns the children attributes of some attributes.
      def children_of(attributes)
        statement_executions.filter(:parent => attributes[:id]).all
      end
      
      # Branches some statement _who_ and returns new attributes for it
      def branch(attributes, who, *args)
        id = statement_executions.insert(
          :process            => attributes[:process],
        	:process_execution  => attributes[:process_execution],
        	:statement          => who.statement_token,
        	:parent             => attributes[:id],
          :status             => 'pending')
        newones = statement_executions.filter(:id => id).first
        newones
      end
      
      # Close some statement from attributes
      def close(attributes, statement)
        ::CliPrEasy::DAS.transaction do |t|
          t.statement_executions.filter(:id => attributes[:id]).update(:status => 'ended', :ended_at => Time.now)
          if CliPrEasy::Engine::Process === statement
            t.process_executions.filter(:id => attributes[:process_execution]).update(:status => 'ended', :ended_at => Time.now)
          end
        end
      end
      
      # Finds the evaluator for a given statement execution
      def evaluator(statement_execution)
        process = CliPrEasy::Engine::Process[statement_execution[:process]]
        process_execution = statement_execution[:process_execution]
        process.evaluator(process_execution)
      end
      
      # Evaluates an expression
      def evaluate(attributes, expression)
        evaluator(attributes).instance_eval(expression)
      end
      
    end # class ProcessStateBackend
  end # module State
end # module CliPrEasy