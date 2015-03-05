#Author - Upendra Sabnis
require_relative '../core/TwitterRequest'

class SearchGeo < TwitterRequest

  def initialize(args)
    super args
  end

  def request_name
    "GeoSearch"
  end

  def twitter_endpoint
    "/geo/search"
  end

  def url
    'https://api.twitter.com/1.1/geo/search.json'
  end

  def success(response)
    log.info("SUCCESS")
    georesults = JSON.parse(response.body)['result']['places']
    log.info("#{georesults.size} results(s) received.")
    yield georesults
  end

  def error(response)
    if response.code == 404
      puts "No geo search results found."
      return
    end
    super
  end

end
