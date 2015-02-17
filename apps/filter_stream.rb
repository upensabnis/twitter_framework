require_relative '../requests/FilterTrackStream'

require 'trollop'

$continue = true

Signal.trap(:INT) do
  $continue = false
end

USAGE = %Q{
filter_stream: Submit keywords to Twitter's Streaming API.

Usage:
  ruby filter_stream.rb <options> <terms>

  terms: The name of a file containing search terms, one per line.

  The terms must match the requirements documented here:

     <https://dev.twitter.com/streaming/overview/request-parameters>

  for the 'track' parameter.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "public_stream 0.1 (c) 2015 Kenneth M. Anderson"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:terms] = ARGV[0]

  unless File.exist?(opts[:terms])
    Trollop::die "'#{opts[:terms]}' must point to a file containing search terms."
  end

  opts
end

def load_terms(input_file)
  terms = []
  IO.foreach(input_file) do |term|
    terms << term.chomp
  end
  terms
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line

  data   = { props: input[:props], terms: load_terms(input[:terms]) }

  args   = { params: {}, data: data }

  twitter = FilterTrackStream.new(args)

  puts "Starting connection to Twitter's Public Streaming API."
  puts "Looking for Tweets containing the following terms:"
  puts data[:terms]

  File.open('streaming_tweets.json', 'w') do |f|
    twitter.collect do |tweet|
      f.puts "#{tweet.to_json}\n"
      puts "#{tweet["text"]}" if tweet.has_key?("text")
      if !$continue
        f.flush
        twitter.request_shutdown
      end
    end
  end

end
