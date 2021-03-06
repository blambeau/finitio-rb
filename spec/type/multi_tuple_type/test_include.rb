require 'spec_helper'
module Finitio
  describe MultiTupleType, "include?" do

    let(:a)      { Attribute.new(:a, intType)        }
    let(:maybe_b){ Attribute.new(:b, intType, false) }

    let(:type){ MultiTupleType.new(heading) }

    subject{ type.include?(arg) }

    context 'without extra allowed' do
      let(:heading){
        Heading.new([a, maybe_b])
      }

      context 'when a valid hash and both attributes' do
        let(:arg){ {a: 12, b: 14} }

        it{ should eq(true) }
      end

      context 'when a valid hash but no optional attribute' do
        let(:arg){ {a: 12} }

        it{ should eq(true) }
      end

      context 'when an invalid hash (too many attributes)' do
        let(:arg){ {a: 12, c: 15} }

        it{ should eq(false) }
      end

      context 'when an invalid hash (too few attributes)' do
        let(:arg){ {b: 12} }

        it{ should eq(false) }
      end

      context 'when an invalid hash (wrong type)' do
        let(:arg){ {a: 12, b: 15.0} }

        it{ should eq(false) }
      end

      context 'when an invalid hash (wrong type II)' do
        let(:arg){ {a: 12.0, b: 15} }

        it{ should eq(false) }
      end
    end

    context 'with allow_extra set to true' do
      let(:heading){
        Heading.new([a, maybe_b], allow_extra: true)
      }

      context 'when valid hash, yet with no extra attribute' do
        let(:arg){ {a: 12} }

        it{ should eq(true) }
      end

      context 'when valid hash, yet with extra attributes' do
        let(:arg){ {a: 12, c: 15} }

        it{ should eq(true) }
      end
    end

    context 'with allow_extra set to a specific type' do
      let(:heading){
        Heading.new([a, maybe_b], allow_extra: negInt)
      }

      context 'when valid hash, yet with no extra attribute' do
        let(:arg){ {a: 12} }

        it{ should eq(true) }
      end

      context 'when a valid b' do
        let(:arg){ {a: 12, b: 15} }

        it{ should eq(true) }
      end

      context 'when a valid c' do
        let(:arg){ {a: 12, b: 15, c: -120} }

        it{ should eq(true) }
      end

      context 'when an invalid c' do
        let(:arg){ {a: 12, b: 15, c: 120} }

        it{ should eq(false) }
      end
    end

  end
end
