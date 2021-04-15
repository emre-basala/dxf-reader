module DXF
  class Dimension < Entity

    # 5 hanlde

    attr_reader :pairs
    attr_accessor :x1, :y1, :z1
    attr_accessor :x2, :y2, :z2
    attr_accessor :x3, :y3, :z3
    attr_accessor :x4, :y4, :z4

    attr_accessor :handle
    attr_accessor :layer_name
    attr_accessor :block_name
    attr_accessor :drawn_as_text
    attr_accessor :locally_referenced
    attr_accessor :style_name
    attr_accessor :rotation_angle

    def parse_pair(code, value)
      @pairs ||= {}
      case code
      when '10' then self.x1 = value.to_f
      when '20' then self.y1 = value.to_f
      when '30' then self.z1 = value.to_f

      when '11' then self.x2 = value.to_f
      when '21' then self.y2 = value.to_f
      when '31' then self.z2 = value.to_f

      when '13' then self.x3 = value.to_f
      when '23' then self.y3 = value.to_f
      when '33' then self.z3 = value.to_f

      when '14' then self.x4 = value.to_f
      when '24' then self.y4 = value.to_f
      when '34' then self.z4 = value.to_f

      when '5' then self.handle = value
      when '8' then self.layer_name = value
      when '2' then self.block_name = value
      when '1' then self.drawn_as_text = value.to_s == '<>'
      when '70' then self.locally_referenced = value.to_s == '32'
      when '3' then self.style_name = value
      when '50' then self.rotation_angle = value.to_f

      else
         @pairs[code] = value
        super # Handle common and unrecognized codes
      end

    end

    def debug
      # puts "keys: " + pairs.keys.join(",")
    end

    def initialize(*args)
      # puts "initialize #{self.class.to_s}"
      # puts args.to_s
    end

  end
end
