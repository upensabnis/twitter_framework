require 'json'

module TwitterProperties

  def load_props(input)
    input = File.open(input)
    convert_props(JSON.parse(input.read))
  end

  def convert_props(input)
    props = {}
    input.keys.each do |key|
      props[key.to_sym] = input[key]
    end
    props
  end

  private :convert_props, :load_props

end
