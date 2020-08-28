module DXF
  class Dimension < Entity

    def parse_pair(code, value)
      puts "[parse_pair] #{code}:#{value}"
    end

    def initialize(*args)
      puts "initialize #{self.class.to_s}"
      puts args.to_s
    end

  end
end
