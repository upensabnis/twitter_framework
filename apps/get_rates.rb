require_relative '../requests/RateLimits'

require 'trollop'

USAGE = %Q{
get_rates: Retrieve Twitter rate limit information for a given endpoint.

Usage:
  ruby get_rates.rb <options> <endpoint>

  <endpoint>: A Twitter REST API endpoint.

  Examples  : /application/rate_limit_status
              /status/user_timeline
              /friends/ids

The following options are supported:
}

def parse_endpoint(endpoint)
  pattern = /^\/(?<resource>\w+)\/\w+$/
  data    = pattern.match(endpoint)
  if data.nil?
    Trollop::die "Endpoint must be of form '/resource/method'"
  end
  [data[:resource], endpoint]
end

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_rates 0.1 (c) 2015 Kenneth M. Anderson"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  resource, endpoint = parse_endpoint(ARGV[0])

  opts[:resource] = resource
  opts[:endpoint] = endpoint
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { resources: input[:resource] }
  data   = { endpoint: input[:endpoint], props: input[:props] }

  args     = { params: params, data: data }
  twitter  = RateLimits.new(args)

  twitter.collect do |info|
    puts info.inspect
  end

end
