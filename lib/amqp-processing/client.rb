require 'mq'
require 'amqp-processing/logging'

module AMQPProcessing


class Client
  
  include Logging
  
  #A Processing::App which will receive all method calls made on peer Client objects.
  attr_reader :app
  def app=(value)
    @app = value
    undef_insecure_methods(@app)
  end
  
  #The server connection Thread, set by the connect method.
  attr_reader :thread
  
  def initialize
    @client_id = rand(100000000).to_i
    @call_fanout = nil
  end
  
  def connect(options = {})
    Thread.abort_on_exception = true
    @thread = Thread.new do
      AMQP.start(options) do
        @call_fanout = MQ.fanout('calls')
        @call_queue = MQ.queue("q.#{rand(10000).to_i}").bind(@call_fanout, :key => "q.*").subscribe do |message|
          call = Marshal.load(message)
          sender_id, name, arguments = call.shift, call.shift, *call
          if sender_id == @client_id
            log.debug "sender_id #{sender_id} == @client_id #{@client_id}, ignoring"
          else
            log.debug "received from #{sender_id}: #{name}, #{arguments.inspect}"
            @app.__send__(name, *arguments)
          end
        end
      end
    end
  end
  
  def method_missing(name, *arguments)
    log.debug "sending as #{@client_id}: #{name}, #{arguments.inspect}"
    return_value = @app.__send__(name, *arguments)
    while @call_fanout == nil
      log.debug "Not yet connected to publishing queue, sleeping"
      sleep 1
    end
    @call_fanout.publish(Marshal.dump([@client_id, name, arguments]))
    return_value
  end
  
  private
  
    def undef_insecure_methods(object)
      class << object
        %w{
          clone
          define_singleton_method
          display
          dup
          extend
          freeze
          instance_eval
          instance_exec
          instance_variable_defined?
          instance_variable_get
          instance_variable_set
          instance_variables
          public_send
          remove_instance_variable
          save
          send
          tap
          library_loaded?
          load_java_library
          load_libraries
          load_library
          load_ruby_library
        }.each do |method|
          if method_defined?(method.to_sym)
            undef_method(method.to_sym)
          end
        end
      end
    end
  
  
  
end


end