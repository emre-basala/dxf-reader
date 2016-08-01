module DXF
  class Vertex < Entity

    attr_accessor :color_code
    attr_accessor :x, :y, :bulge, :flag

    # ########
    # Bulge (optional; default is 0).
    # The bulge is the tangent of one fourth the included angle
    # for an arc segment, made negative
    # if the arc goes clockwise from the
    # start point to the endpoint.
    # A bulge of 0 indicates a straight segment,
    # and a bulge of 1 is a semicircle.

    # ########
    # Vertex flags:
    # 1 = Extra vertex created by curve-fitting
    # 2 = Curve-fit tangent defined for this vertex. A curve-fit tangent direction of 0 may be omitted from DXF output but is significant if this bit is set.
    # 4 = Not used
    # 8 = Spline vertex created by spline-fitting
    # 16 = Spline frame control point
    # 32 = 3D polyline vertex
    # 64 = 3D polygon mesh
    # 128 = Polyface mesh vertex

    # 50


    def parse_pair(code, value)
      case code
        when '10' then self.x = value.to_f
        when '20' then self.y = value.to_f
        when '70' then self.flag = value.to_f
        when '42' then self.bulge = value.to_f
        when '62' then self.color_code = value.to_i
      end
    end

    def start_x
      @x
    end

    def start_y
      @y
    end
  end
end
