module DXF
    class EntityParser
        # @!attribute points
        #   @return [Array]  points
        attr_accessor :points

        attr_reader :handle
        attr_reader :layer

        def initialize(type_name)
            @flags = nil
            @points = Array.new { Point.new }
            @type_name = type_name

            @point_index = Hash.new {|h,k| h[k] = 0}
        end

        def parse_pair(code, value)
          case code
            when 5 then @handle = value # Fixed
            when 8 then @layer = value # Fixed
            when 62 then @color_code = value # Fixed
            when 10, 20, 30
              k = Parser.code_to_symbol(code)
              i = @point_index[k]
              @points[i] = Parser.update_point(@points[i], k => value)
              @point_index[k] += 1
            when 70  then @flags = value
          end
        end

        def to_entity
          case @type_name
            when 'LWPOLYLINE'

              LWPolyline.new(*points).tap do |entity|
                entity.color_code = @color_code
              end

            when 'POLYLINE'

              Polyline.new(*points).tap do |entity|
                entity.color_code = @color_code
              end

          end
        end
    end
end
