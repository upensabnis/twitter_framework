require_relative '../core/StreamingTwitterRequest'

class FilterTrackStream < StreamingTwitterRequest

  def request_name
    "FilterStream"
  end

  def twitter_endpoint
    "/statuses/filter"
  end

  def url
    'https://stream.twitter.com/1.1/statuses/filter.json'
  end

  def authorization
    #params = { track: prepare_terms.join(",") }
    params = { track: data[:terms].join(",") }
    header = SimpleOAuth::Header.new("POST", url, params, props)
    { "Authorization" => header.to_s }
  end

  def body
    "track=" + prepare_terms.join(",")
  end

  def prepare_terms
    data[:terms].map { |term| prepare(term) }
  end

  def options
    options = {}
    options[:method]  = :post
    options[:headers] = authorization
    options[:body]    = body
    options
  end

end
