require 'simple_oauth'

module TwitterParams

  @@parser = URI::Parser.new

  def include_param?(param)
    return true
  end

  def prepare(param)
    @@parser.escape(param.to_s, /[^a-z0-9\-\.\_\~]/i)
  end

  def escaped_params
    result = {}
    params.keys.each do |key|
      result[key] = prepare(params[key]) if include_param?(key)
    end
    result
  end

  def display_params
    result = []
    escaped_params.keys.each do |key|
      result << "#{key}=#{escaped_params[key]}" if include_param?(key)
    end
    result.join("&")
  end

  protected :include_param?
  private   :display_params, :escaped_params, :prepare

end
