# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

class Logger  
  def format_message(level, time, progname, msg)  
    "#{time.to_s(:db)} #{level} -- #{msg}\n"  
  end  
end  


