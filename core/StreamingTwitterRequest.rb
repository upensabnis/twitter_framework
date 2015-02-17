require_relative "TwitterRequest"

class StreamingTwitterRequest < TwitterRequest

  def initialize(args)
    super(args)
    @buffer   = ""
    @continue = true
  end

  def request_shutdown
    @continue = false
  end

  def process
    index = @buffer.index("\r\n")
    while index
      yield @buffer[0..index-1]
      @buffer = @buffer[index+2..@buffer.length]
      index = @buffer.index("\r\n")
    end
  end

  def collect
    @request = Typhoeus::Request.new(url, options)
    @request.on_headers do |response|
      if response.code != 200
        error(response)
      end
    end
    @request.on_body do |data|
      @buffer = @buffer + data
      process do |msg|
        begin
          yield JSON.parse(msg)
        rescue JSON::ParserError
          # ignore empty message
        end
      end
      Thread.current.exit unless @continue
    end
    @request.on_complete do |response|
      request_shutdown
    end
    @request.run
  end

end
