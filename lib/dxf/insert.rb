module DXF
  class Insert < Entity
    attr_accessor :entity_type

    def parse_pair(code, value)
      case code
        when '0' then self.entity_type = value.to_i
        else
          super   # Handle common and unrecognized codes
      end
    end
  end
end
