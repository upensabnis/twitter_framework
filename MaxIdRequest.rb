require_relative 'TwitterRequest'

class MaxIdRequest < TwitterRequest

  def initialize(args)
    super args
    params[:max_id] = 0
  end

  def include_param?(param)
    if param == :max_id
      if params[param] == 0
        return false
      end
    end
    return true
  end

  def init_condition
    raise NotImplementedError, "MaxIdRequest: Loop Not Initialized"
  end

  def condition
    raise NotImplementedError, "MaxIdRequest: Condition Not Specified"
  end

  def update_condition(data)
    raise NotImplementedError, "MaxIdRequest: Condition Not Updated"
  end

  def collect
    init_condition
    while condition
      response = make_request
      if response.code == 200
        success(response) do |tweets|
          yield tweets
          params[:max_id] = (tweets[-1]['id'] - 1) if tweets.size > 0
          update_condition(tweets)
        end
      else
        error(response)
      end
    end
  end

end
