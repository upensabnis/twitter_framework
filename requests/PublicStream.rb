require_relative '../core/StreamingTwitterRequest'

class PublicStream < StreamingTwitterRequest

  def request_name
    "PublicStream"
  end

  def twitter_endpoint
    "/statuses/sample"
  end

  def url
    'https://stream.twitter.com/1.1/statuses/sample.json'
  end

end
