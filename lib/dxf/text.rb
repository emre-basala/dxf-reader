module DXF
  class Text < Entity

    attr_accessor :x1, :y1, :x2, :y2

    attr_accessor :rotation
    attr_accessor :content
    attr_accessor :color_code
    attr_accessor :scale
    # 71
    attr_accessor :text_generation

    # Text generation flags (optional, default = 0):
    # 2 = Text is backward (mirrored in X).
    # 4 = Text is upside down (mirrored in Y).

    # 72
    attr_accessor :text_justification

    attr_accessor :lines

    # Horizontal text justification type (optional, default = 0) integer codes (not bit-coded)
    # 0 = Left; 1= Center; 2 = Right
    # 3 = Aligned (if vertical alignment = 0)
    # 4 = Middle (if vertical alignment = 0)
    # 5 = Fit (if vertical alignment = 0)
    # See the Group 72 and 73 integer codes table for clarification.
    def parse_pair(code, value)
      case code
        when '10' then self.x1 = value.to_f
        when '20' then self.y1 = value.to_f
        when '11' then self.x2 = value.to_f
        when '21' then self.y2 = value.to_f
        when '1' then self.content = value
        when '62' then self.color_code = value.to_f
        when '50' then self.rotation = value.to_f
        when '71' then self.text_generation = value.to_f
        when '72' then self.text_justification = value.to_f
      end
    end

    def initialize(*args)
      @lines = []
    end

    def dimension_text?
      lines.any?
    end

    def add_line(line)
      lines << line
    end

  end
end
