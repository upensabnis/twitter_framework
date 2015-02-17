require_relative '../core/MaxIdRequest'

class Timeline < MaxIdRequest

  def initialize(args)
    super args
    params[:count] = 200
    @count = 0
  end

  def request_name
    "Timeline"
  end

  def twitter_endpoint
    "/statuses/user_timeline"
  end

  def url
    'https://api.twitter.com/1.1/statuses/user_timeline.json'
  end

  def success(response)
    log.info("SUCCESS")
    tweets = JSON.parse(response.body)
    @count += tweets.size
    log.info("#{tweets.size} tweet(s) received.")
    log.info("#{@count} total tweet(s) received.")
    yield tweets
  end

  def init_condition
    @num_success = 0
  end

  def condition
    @num_success < 16
  end

  def update_condition(tweets)
    if tweets.size > 0
      @num_success += 1
    else
      @num_success = 16
    end
  end

end
