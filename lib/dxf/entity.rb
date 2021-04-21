require 'geometry'

require_relative 'cluster_factory'

module DXF
    Point = Geometry::Point

    # {Entity} is the base class for everything that can live in the ENTITIES block
    class Entity
      TypeError = Class.new(StandardError)

      include ClusterFactory

      attr_accessor :handle
      attr_accessor :layer

      attr_accessor :parent

      def self.new(type)
        ("DXF::" + type.capitalize).constantize.new.tap do |entity|
          EntitySpace.instance.add(entity)
        end
      end

      def parse_pair(code, value)
          # Handle group codes that are common to all entities
          #  These are from the table that starts on page 70 of specification
          case code
          when '5'
              self.handle = value
          when '8'
              self.layer = value
          else
              p "Unrecognized entity group code: #{code} #{value}"
          end
      end

      private

      def point_from_values(*args)
        Geometry::Point[args.flatten.reverse.drop_while {|a| not a }.reverse]
      end
    end
end
