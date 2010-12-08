require 'logger'

module AMQPProcessing
  
module Logging
  
  attr_accessor :logger
  
  #Returns the assigned logger, or creates a new Logger with no output stream.
  def log
    @logger ||= Logger.new(nil)
    @logger
  end
  
end

end