require_relative 'entity_parser'

module DXF
  class SplineParser < EntityParser
    # @!attribute points
    #   @return [Array]  points
    attr_accessor :points

    attr_reader :closed, :periodic, :rational, :planar, :linear
    attr_reader :degree
    attr_reader :knots

    def initialize
        super 'SPLINE'
        @fit_points = []
        @knots = []
        @weights = []

        @fit_point_index = Hash.new {|h,k| h[k] = 0}
    end

    def parse_pair(code, value)
        case code
        when 11, 21, 31
            k = Parser.code_to_symbol(code)
            i = @fit_point_index[k]
            @fit_points[i] = Parser.update_point(@fit_points[i], k => value)
            @fit_point_index[k] += 1
        when 12, 22, 32 then    @start_tangent = update_point(@start_tangent, Parser.code_to_symbol(code) => value)
        when 13, 23, 33 then    @end_tangent = update_point(@end_tangent, Parser.code_to_symbol(code) => value)
        when 40 then    knots.push value.to_f
        when 41 then    @weights.push value
        when 42 then    @knot_tolerance = value
        when 43 then    @control_tolerance = value
        when 44 then    @fit_tolerance = value
        when 70
            value = value.to_i
            @closed = value[0].zero? ? nil : true
            @periodic = value[1].zero? ? nil : true
            @rational = value[2].zero? ? nil : true
            @planar = value[3].zero? ? nil : true
            @linear = value[4].zero? ? nil : true
        when 71 then    @degree = value
        when 72 then    @num_knots = value
        when 73 then    @num_control_points = value
        when 74 then    @num_fit_points = value
        else
            super
        end
    end

    def to_entity
        raise ParseError, "Wrong number of control points" unless points.size == @num_control_points

        # If all of the points lie in the XY plane, remove the Z component from each point
        if planar && points.all? {|a| a.z.zero?}
        @points.map! {|a| Geometry::Point[a[0, 2]]}
        end

        if knots.size == 2*points.size
        # Bezier?
        if knots[0,points.size].all?(&:zero?) && (knots[-points.size,points.size].uniq.size==1)
            Bezier.new *points
        end
        else
        Spline.new degree:degree, knots:knots, points:points
        end
    end
  end
end
