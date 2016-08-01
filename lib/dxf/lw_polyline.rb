module DXF
  class LWPolyline < Entity
    # @!attribute points
    #  @return [Array<Point>] The points that make up the polyline
    attr_reader :points
    attr_reader :entities
    attr_reader :start_x, :start_y
    attr_accessor :color_code

    def initialize(*points)
      @start_x = nil
      @start_y = nil
      @points = points.map {|a| Point[a]}
      @entities = []
      self.tap do |lwpolyline|
        EntitySpace.instance.add(self)
      end
    end

    # Return the individual line segments
    def lines
      points.each_cons(2).map {|a,b| Line.new a, b}
    end

    def add_entity(entity)
      @start_x ||= entity.start_x
      @start_y ||= entity.start_y
      @entities << entity
      entity.parent = self
    end
  end
end
