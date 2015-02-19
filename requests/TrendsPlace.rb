require_relative '../core/TwitterRequest'

class TrendsPlace < TwitterRequest

  def initialize(args)
    super args
  end

  def request_name
    "PlaceTrends"
  end

  def twitter_endpoint
    "/trends/place"
  end

  def url
    'https://api.twitter.com/1.1/trends/place.json'
  end

  def success(response)
    log.info("SUCCESS")
    trends = JSON.parse(response.body)[0]['trends']
    log.info("#{trends.size} trends(s) received.")
    yield trends
  end

  def error(response)
    if response.code == 404
      puts "No trending topic information for this Where On Earth ID."
      return
    end
    super
  end

end


