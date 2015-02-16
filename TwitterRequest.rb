require 'bundler/setup'

require_relative 'Logging'
require_relative 'Properties'

require 'json'
require 'simple_oauth'
require 'time'
require 'typhoeus'

class TwitterRequest

  include TwitterLog
  include TwitterProperties

  @@parser = URI::Parser.new
  @@rates  = {}

  attr_reader :data, :log, :params, :props

  def initialize(args)
    @params   = args.fetch(:params)
    @data     = args.fetch(:data)
    @log      = args[:log] || default_logger
    @props    = load_props(@data[:props])
  end

  def url
    raise NotImplementedError, "No URL Specified for the Request"
  end

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

  def error(response)
    puts "FAILURE      : #{Time.now}"
    puts "Response Code: #{response.code}"
    puts "Response Info: #{response.status_message}"
    raise RuntimeError, "TwitterRequest Failed: #{response.code}"
  end

  def request_name
    raise NotImplementedError, "Request Name Not Specified"
  end

  def twitter_endpoint
    raise NotImplementedError, "Twitter Endpoint Not Specified"
  end

  def success(response)
    raise NotImplementedError, "Success Handler Not Specified"
  end

  def prepare(param)
    @@parser.escape(param.to_s, /[^a-z0-9\-\.\_\~]/i)
  end

  def include_param?(param)
    return true
  end

  def escaped_params
    result = {}
    params.keys.each do |key|
      result[key] = prepare(params[key]) if include_param?(key)
    end
    result
  end

  def authorization
    header = SimpleOAuth::Header.new("GET", url, escaped_params, props)
    { 'Authorization' => header.to_s }
  end

  def options
    options = {}
    options[:method]  = :get
    options[:headers] = authorization

    request_params = {}
    escaped_params.keys.each do |key|
      request_params[key] = escaped_params[key] if include_param?(key)
    end

    options[:params]  = request_params
    options
  end

  def display_params
    result = []
    escaped_params.keys.each do |key|
      result << "#{key}=#{escaped_params[key]}"  if include_param?(key)
    end
    result.join("&")
  end

  def make_request
    check_rates
    request = Typhoeus::Request.new(url, options)
    log.info("REQUESTING: #{request.base_url}?#{display_params}")
    response = request.run
    @rate_count = @rate_count - 1
    response
  end

  def collect
    response = make_request
    if response.code == 200
      success(response) do |data|
        yield data
      end
    else
      error(response)
    end
  end

  public    :collect
  protected :error, :include_param?, :make_request, :success, :url
  private   :authorization, :escaped_params, :options, :prepare

end
