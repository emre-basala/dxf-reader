module DXF
  class Circle < Entity
    attr_accessor :x, :y, :z
    attr_accessor :radius
    attr_accessor :color_code

    def parse_pair(code, value)
      case code
        when '10' then self.x = value.to_f
        when '20' then self.y = value.to_f
        when '30' then self.z = value.to_f
        when '40' then self.radius = value.to_f
        when '62' then self.color_code = value.to_i
        else
          super # Handle common and unrecognized codes
        end
    end

    # @!attribute [r] center
    #   @return [Point]  the composed center of the {Circle}
    def center
      a = [x, y, z]
      a.pop until a.last
      Geometry::Point[*a]
    end
  end
end
