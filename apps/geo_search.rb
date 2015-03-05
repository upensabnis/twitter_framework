require_relative '../requests/SearchGeo'

require 'trollop'

USAGE = %Q{
geo_search: Retrieve search information based on lattitude and longitude.

Usage:
  1. ruby geo_search.rb <options> <lattitude> <longitude> OR 
      <lattitude>: Lattitude of a place
      Example: 40.014986 is the lattitude for Boulder

      <longitude>: Longitude of a place
      Example: -105.270546 is the longitude for Boulder

  2. ruby geo_search.rb <options> <query> OR 
      <query>: Name of the place
      Example: Boulder is the query parameter
  

  3.  ruby geo_search.rb <options> <ip>
      <ip>: IP address of machine from where you are connecting
      Example: Current IP address of my machine  

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "geo_search 0.1 (c) 2015 Upendra Sabnis"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid file"
  end

  opts[:lat] = ARGV[0]
  opts[:long] = ARGV[1]
  #opts[:query] = ARGV[0]
  #opts[:ip] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { lat: input[:lat],long: input[:long] }
  #params = { query: input[:query] }
  #params = { ip: input[:ip] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = SearchGeo.new(args)

  puts "Searching the geo locations for Lattitude: #{input[:lat]} and Longitude: #{input[:long]}"

  File.open('geoSearch.json', 'w') do |f|
    twitter.collect do |georesults|
      georesults.each do |georesult|
        f.puts "#{georesult.to_json}\n"
      end
    end
  end

  puts "DONE."

end