module DXF
  class Line < Entity
    attr_reader :first, :last
    attr_accessor :color_code
    attr_accessor :x1, :y1, :z1
    attr_accessor :x2, :y2, :z2

    def parse_pair(code, value)
      case code
      when '10' then self.x1 = value.to_f
      when '20' then self.y1 = value.to_f
      when '30' then self.z1 = value.to_f
      when '11' then self.x2 = value.to_f
      when '21' then self.y2 = value.to_f
      when '31' then self.z2 = value.to_f
      when '62' then self.color_code = value.to_i
      else
        super # Handle common and unrecognized codes
      end
    end

    def initialize(*args)
      @first, @last = *args
    end

    def start_x
      x1
    end

    def start_y
      x2
    end

    # @!attribute [r] first
    # @return [Point]  the starting point of the {Line}
    def first
      @first ||= point_from_values(x1, y1, z1)
    end

    # @!attribute [r] last
    # @return [Point]  the end point of the {Line}
    def last
      @last ||= point_from_values(x2, y2, z2)
    end
  end
end
