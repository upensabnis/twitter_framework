require_relative '../requests/PublicStream'

require 'trollop'

$continue = true

Signal.trap(:INT) do
  $continue = false
end

USAGE = %Q{
public_stream: Connect to the Twitter Streaming API's public stream.

Usage:
  ruby public_stream.rb <options>

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

  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line

  data   = { props: input[:props] }

  args   = { params: {}, data: data }

  twitter = PublicStream.new(args)

  puts "Starting connection to Twitter's Public Streaming API."

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
