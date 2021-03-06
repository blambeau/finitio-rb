require 'spec_helper'
module Finitio
  describe StructType, "include?" do

    let(:type){ StructType.new([intType, floatType]) }

    subject{ type.include?(arg) }

    context 'when a valid array' do
      let(:arg){ [12, 14.0] }

      it{ should eq(true) }
    end

    context 'when not an array' do
      let(:arg){ "bar" }

      it{ should eq(false) }
    end

    context 'when an invalid array (too few attributes)' do
      let(:arg){ [ 12 ] }

      it{ should eq(false) }
    end

    context 'when an invalid array (too many attributes)' do
      let(:arg){ [ 12, 14.0, "foo" ] }

      it{ should eq(false) }
    end

    context 'when an invalid array (wrong type)' do
      let(:arg){ [ 12, 'bar' ] }

      it{ should eq(false) }
    end

  end
end
