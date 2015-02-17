require_relative '../core/MaxIdRequest'

class Search < MaxIdRequest

  def initialize(args)
    super args
    params[:count] = 100
    @count = 0
  end

  def request_name
    "Search"
  end

  def twitter_endpoint
    "/search/tweets"
  end

  def url
    'https://api.twitter.com/1.1/search/tweets.json'
  end

  def success(response)
    log.info("SUCCESS")
    tweets = JSON.parse(response.body)['statuses']
    @count += tweets.size
    log.info("#{tweets.size} tweet(s) received.")
    log.info("#{@count} total tweet(s) received.")
    yield tweets
  end

  def init_condition
    @last_count = 1
  end

  def condition
    @last_count > 0
  end

  def update_condition(tweets)
    @last_count = tweets.size
  end


end
