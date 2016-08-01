module DXF
  class Seqend < Entity

    attr_accessor :layer_name

    def parse_pair(code, value)
      case code
        when '8' then self.layer_name = value
      end
    end


    def initialize(*args)
    end

  end
end
