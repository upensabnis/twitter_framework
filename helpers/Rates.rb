require 'simple_oauth'
require 'time'
require 'typhoeus'

module TwitterRates

  @@rates  = {}

  def rate_url
    "https://api.twitter.com/1.1/application/rate_limit_status.json"
  end

  def rate_options
    options           = {}
    options[:method]  = :get

    header = SimpleOAuth::Header.new("GET", rate_url, {}, props)

    options[:headers] = { 'Authorization' => header.to_s }
    options
  end

  def refresh_rates
    request     = Typhoeus::Request.new(rate_url, rate_options)
    response    = request.run
    @@rates     = JSON.parse(response.body)['resources']
    @rate_count = twitter_calls_remaining
  end

  def resource_from_endpoint
    pattern = /^\/(?<resource>\w+)\/\w+$/
    data    = pattern.match(twitter_endpoint)
    data[:resource]
  end

  def twitter_window
    info = @@rates[resource_from_endpoint][twitter_endpoint]
    Time.at(info['reset']) + 10
  end

  def twitter_calls_remaining
    info = @@rates[resource_from_endpoint][twitter_endpoint]
    info['remaining']
  end

  def check_rates
    refresh_rates if @@rates.size == 0
    refresh_rates if Time.now > twitter_window
    return if @rate_count > 0
    delta = twitter_window - Time.now
    log.info "Sleeping for #{delta} seconds"
    sleep delta
    refresh_rates
  end

end
