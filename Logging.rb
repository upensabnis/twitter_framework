require 'logger'

module TwitterLog

  class CustomFormatter < Logger::Formatter
    def call(severity, time, progname, msg)
    "#{time}: #{progname}: #{msg2str(msg)}\n"
    end
  end

  def default_logger
    logger = Logger.new($stdout)
    logger.progname = request_name;
    logger.formatter = CustomFormatter.new
    logger
  end

  private :default_logger

end
