require_relative 'entity_space'
require_relative 'entity'
require_relative 'circle'
require_relative 'dimension'
require_relative 'arc'
require_relative 'line'
require_relative 'vertex'
require_relative 'text'
require_relative 'insert'
require_relative 'seqend'
require_relative 'lw_polyline'
require_relative 'polyline'
require_relative 'spline_parser'
require_relative 'spline'
require_relative 'bezier'
require_relative 'entity_parser'

module DXF
 class Parser
    ParseError = Class.new(StandardError)

    # @!attribute entities
    #   @return [Array]  the entities that comprise the drawing
    attr_accessor :entities

    # @!attribute header
    #   @return [Hash]  the header variables
    attr_accessor :header

    def initialize(units=:mm)
      @entities = []
      @header = {}
    end

    def parse(io)
      parse_pairs io do |code, value|
        next if '999' == code
        raise ParseError, "DXF files must begin with group code 0, not #{code}" unless '0' == code
        raise ParseError, "Expecting a SECTION, not #{value}" unless 'SECTION' == value
        parse_section(io)
      end
      EntitySpace.instance.tie_entities
      self
    end

    private

    def read_pair(io)
      code = io.gets.strip
      value = io.gets.strip
      value = case code.to_i
        when 1..9
            value.to_s
        when 10..18, 20..28, 30..37, 40..49
            value.to_f
        when 50..58
            value.to_f    # degrees
        when 70..78, 90..99, 270..289
            value.to_i
        else
            value
      end

      [code, value]
    end

    def parse_pairs(io, &block)
        while not io.eof?
        code, value = read_pair(io)
        case [code, value]
          when ['0', 'ENDSEC']
          yield code, value   # Allow the handler a chance to clean up
          return
          when ['0', 'EOF']        then return
          else
          yield code, value
        end
        end
    end

    def parse_section(io)
        code, value = read_pair(io)
        raise ParseError, 'SECTION must be followed by a section type' unless '2' == code

        case value
        when 'BLOCKS' then parse_pairs(io) {|code, value|}  # Ignore until implemented
        when 'CLASSES' then parse_pairs(io) {|code, value|}  # Ignore until implemented
        when 'ENTITIES'
            parse_entities(io)
        when 'HEADER'
            parse_header(io)
        when 'OBJECTS' then parse_pairs(io) {|code, value|}  # Ignore until implemented
        when 'TABLES' then parse_pairs(io) {|code, value|}  # Ignore until implemented
#        when 'THUMBNAILIMAGE'
        else
            raise ParseError, "Unrecognized section type '#{value}'"
        end
    end

    # Parse the ENTITIES section
    def parse_entities(io)
      parser = nil
      parse_pairs io do |code, value|
        if 0 == code.to_i
          if parser
            entities.push parser.to_entity
            parser = nil
          end

          # Nothing to do
          next if ('ENDSEC' == value)

          if ('LWPOLYLINE' == value || 'POLYLINE' == value)
            parser = EntityParser.new(value)
          elsif 'SPLINE' == value
            parser = SplineParser.new
          else
            entities.push Entity.new(value)
          end
        elsif parser
          parser.parse_pair(code.to_i, value)
        else
          entities.last.parse_pair(code, value)
        end
      end
    end

    # Parse the HEADER section
    def parse_header(io)
        variable_name = nil
        parse_pairs io do |code, value|
        case code
            when '0' then next
            when '9'
            variable_name = value
            else
            header[variable_name] = value
        end
        end
    end

# @group Helpers
    def self.code_to_symbol(code)
        case code
        when 10..13 then :x
        when 20..23 then :y
        when 30..33 then :z
        end
    end

    def self.update_point(point, x:nil, y:nil, z:nil)
        a = point ? point.to_a : []
        a[0] = x if x
        a[1] = y if y
        a[2] = z if z
        Geometry::Point[a]
    end
# @endgroup
    end


end