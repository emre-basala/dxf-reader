require "spec_helper"

require "./lib/dxf"

RSpec.describe EntitySpace do

  subject { EntitySpace.instance }

    let!(:random_line_1) { DXF::Line.new().tap { |e| subject.add(e) } }
    let!(:random_line_2) { DXF::Line.new().tap { |e| subject.add(e) } }
    let!(:random_line_3) { DXF::Line.new().tap { |e| subject.add(e) } }

    let!(:text_1) { DXF::Text.new().tap { |e|  subject.add(e) } }
    let!(:text_1_line_1) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_1_line_2) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_1_line_3) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_1_line_4) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_1_line_5) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_1_line_6) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_1_line_7) { DXF::Line.new().tap { |e|  subject.add(e) } }

    let!(:text_2) { DXF::Text.new().tap { |e|  subject.add(e) } }
    let!(:text_2_line_1) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_2_line_2) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_2_line_3) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_2_line_4) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_2_line_5) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_2_line_6) { DXF::Line.new().tap { |e|  subject.add(e) } }
    let!(:text_2_line_7) { DXF::Line.new().tap { |e|  subject.add(e) } }

    let!(:poly_1) { DXF::LWPolyline.new }
    let!(:line_1) { DXF::Line.new.tap { |e|  subject.add(e) } }
    let!(:vertex_1) { DXF::Vertex.new.tap { |e|  subject.add(e) } }
    let!(:seq_1) { DXF::Seqend.new.tap { |e|  subject.add(e) } }
    let!(:line_2) { DXF::Line.new.tap { |e|  subject.add(e) } }
    let!(:poly_2) { DXF::LWPolyline.new }
    let!(:line_3) { DXF::Line.new.tap  { |e|  subject.add(e) } }
    let!(:seq_2) { DXF::Seqend.new.tap  { |e|  subject.add(e) } }
    let!(:line_4) { DXF::Line.new }


  describe "adding entities" do
    it "is an ordered list that knows about before" do
      expect(subject.before(random_line_1)).to be_nil
      expect(subject.before(line_1)).to eq(poly_1)
      expect(subject.before(vertex_1)).to eq(line_1)
      expect(subject.before(seq_1)).to eq(vertex_1)
      expect(subject.before(poly_2)).to eq(line_2)
      expect(subject.before(line_3)).to eq(poly_2)
      expect(subject.before(line_4)).to be_nil
    end

    it "is an ordered list that knows about after" do
      expect(subject.after(poly_1)).to eq(line_1)
      expect(subject.after(line_1)).to eq(vertex_1)
      expect(subject.after(line_3)).to eq(seq_2)
      expect(subject.after(line_4)).to be_nil
    end

    it "adds the entities together" do
      subject.tie_entities
      expect(poly_1.entities).to eq([line_1, vertex_1])
      expect(line_1.parent).to eq(poly_1)
      expect(vertex_1.parent).to eq(poly_1)

      expect(poly_2.entities).to eq([line_3])
      expect(line_3.parent).to eq(poly_2)
    end

    it "adds the dimension lines into dimension text" do
      subject.tie_entities
      expect(text_1.dimension_text?).to eq(true)
      expect(text_1.lines.count).to eq(7)
      expect(text_1.lines[0]).to eq(text_1_line_1)
      expect(text_1.lines[6]).to eq(text_1_line_7)
      expect(text_1_line_1.parent).to eq(text_1)
      expect(text_1_line_7.parent).to eq(text_1)

      expect(text_2.dimension_text?).to eq(true)
      expect(text_2.lines.count).to eq(7)
      expect(text_2.lines[0]).to eq(text_2_line_1)
      expect(text_2.lines[6]).to eq(text_2_line_7)
      expect(text_2_line_1.parent).to eq(text_2)
      expect(text_2_line_7.parent).to eq(text_2)
    end
  end

end