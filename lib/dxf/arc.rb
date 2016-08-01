module DXF
  class Arc < Circle
    attr_accessor :start_angle, :end_angle
    attr_accessor :color_code

    def parse_pair(code, value)
      case code
        when '50' then self.start_angle = value.to_f
        when '51' then self.end_angle = value.to_f
        when '62' then self.color_code = value.to_i
        else
          super   # Handle common and unrecognized codes
      end
    end
  end
end
