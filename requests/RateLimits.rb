require_relative '../core/TwitterRequest'

class RateLimits < TwitterRequest

  def initialize(args)
    super args
  end

  def request_name
    "RateLimits"
  end

  def url
    'https://api.twitter.com/1.1/application/rate_limit_status.json'
  end

  def twitter_endpoint
    "/application/rate_limit_status"
  end

  def success(response)
    log.info("SUCCESS")
    all_rates = JSON.parse(response.body)['resources']
    #puts all_rates.inspect
    rates     = all_rates[params[:resources]][data[:endpoint]]
    count     = rates['remaining']
    time      = Time.at(rates['reset']) + 10
    data      = { count: count, time: time }
    yield data
  end

end
