require_relative '../core/CursorRequest'

class FriendsIds < CursorRequest

  def initialize(args)
    super args
    params[:count] = 5000
    @count = 0
  end

  def request_name
    "FriendsIds"
  end

  def twitter_endpoint
    "/friends/ids"
  end

  def url
    'https://api.twitter.com/1.1/friends/ids.json'
  end

  def success(response)
    log.info("SUCCESS")
    ids = JSON.parse(response.body)['ids']
    @count += ids.size
    log.info("#{ids.size} ids received.")
    log.info("#{@count} total ids received.")
    yield ids
  end

end
