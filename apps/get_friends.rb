require_relative '../requests/FriendsIds'

require 'trollop'

USAGE = %Q{
get_friends: Retrieve user ids followed by a given Twitter screen_name.

Usage:
  ruby get_friends.rb <options> <screen_name>

  <screen_name>: A Twitter screen_name.

The following options are supported:
}

def parse_command_line

  options = {type: :string, required: true}

  opts = Trollop::options do
    version "get_friends 0.1 (c) 2015 Kenneth M. Anderson"
    banner USAGE
    opt :props, "OAuth Properties File", options
  end

  unless File.exist?(opts[:props])
    Trollop::die :props, "must point to a valid oauth properties file"
  end

  opts[:screen_name] = ARGV[0]
  opts
end

if __FILE__ == $0

  STDOUT.sync = true

  input  = parse_command_line
  params = { screen_name: input[:screen_name] }
  data   = { props: input[:props] }

  args     = { params: params, data: data }

  twitter = FriendsIds.new(args)

  puts "Collecting the ids of the Twitter users followed by '#{input[:screen_name]}'"

  File.open('friend_ids.txt', 'w') do |f|
    twitter.collect do |ids|
      ids.each do |id|
        f.puts "#{id}\n"
      end
    end
  end

  puts "DONE."

end
