require_relative '../requests/Search'

require 'trollop'

USAGE = %Q{
find_tweets: Retrieve tweets from the Twitter Search API.

Usage:
  ruby find_tweets.rb <options> <query>

  <query>: Any legal query as specified at:
    <https://dev.twitter.com/rest/public/search>

  The query string should be surrounded by single quotes.

  Example: ruby find_tweets.rb -p oauth.properties '"big data" :)'

The following options are supported:
}

def parse_command_line

  options_1 = {type: :string, required: true}
  options_2 = {type: :string, default: "mixed" }

  opts = Trollop::options do
    version "find_tweets 0.1 (c) 2015 Kenneth M. Anderson"
    banner USAGE
    opt :props, "OAuth Properties File", options_1
    opt :results, "Search Type: mixed, recent, or popular", options_2
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:results] = opts[:results].downcase

  pattern = /mixed|recent|popular/
  match   = pattern.match(opts[:results])

  if match.nil?
    Trollop::die :results, "must be one of 'mixed', 'recent', or 'popular'"
  end

  if ARGV.length > 1
    Trollop::die "query string should be enclosed in single quotes"
  end

  opts[:q] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { q: input[:q], result_type: input[:results] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = Search.new(args)

  puts "Finding tweets that match '#{input[:q]}'"

  File.open('results.json', 'w') do |f|
    twitter.collect do |tweets|
      tweets.each do |tweet|
        f.puts "#{tweet.to_json}\n"
      end
    end
  end

  puts "DONE."

end
