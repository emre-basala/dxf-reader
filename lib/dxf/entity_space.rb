require "singleton"

class EntitySpace
  include Singleton

  attr_accessor :entities

  def initialize
    @entities = []
  end

  def add(entity)
    entities << entity
  end

  def before(entity)
    index = entities.find_index(entity)
    return if index == 0 || index.nil?
    entities[index - 1]
  end

  def after(entity)
    index = entities.find_index(entity)
    return if (index == entities.size - 1) || index.nil?
    entities[index + 1]
  end

  def reset
    @entities = []
  end

  def tie_entities
    tie_polylines
    tie_dimension_texts
  end

  private

  def tie_dimension_texts
    entities.reduce do |mem, entity|

      if entity.is_a?(DXF::Text)
         mem = entity
      elsif entity.is_a?(DXF::Line)
         if mem.is_a?(DXF::Text)
           mem.add_line(entity)
         end
       else
        mem = nil
      end
      mem
    end

  end

  def tie_polylines
    entities.reduce do |mem, entity|
      if mem.is_a?(DXF::LWPolyline) || mem.is_a?(DXF::Polyline)
        if entity.is_a?(DXF::Seqend)
          mem = nil
        else
          mem.add_entity(entity)
        end
      else
        if entity.is_a?(DXF::LWPolyline) || entity.is_a?(DXF::Polyline)
          mem = entity
        end
      end
      mem
    end
  end


end
