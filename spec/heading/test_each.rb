require 'spec_helper'
module Finitio
  describe Heading, "each" do

    let(:a){ Attribute.new(:a, intType) }
    let(:b){ Attribute.new(:b, intType) }
    let(:h){ Heading.new([a, b]) }

    context 'without a block' do

      it 'should return an enumerator' do
        expect(h.each).to be_a(Enumerator)
      end
    end

    context 'with a block' do

      it 'should yield each attribute in turn' do
        seen = []
        h.each do |attr|
          seen << attr
        end
        expect(seen).to eq([a, b])
      end
    end

  end
end