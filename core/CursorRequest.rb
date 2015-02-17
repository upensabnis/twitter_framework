require_relative 'TwitterRequest'

class CursorRequest < TwitterRequest

  def initialize(args)
    super args
    params[:cursor] = -1
  end

  def include_param?(param)
    if param == :cursor
      if params[param] == -1
        return false
      end
    end
    return true
  end

  def collect
    while params[:cursor] != 0
      response = make_request
      if response.code == 200
        success(response) do |tweets|
          yield tweets
          params[:cursor] = JSON.parse(response.body)['next_cursor']
        end
      else
        error(response)
      end
    end
  end

end
