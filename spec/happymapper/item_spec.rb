# frozen_string_literal: true

require 'spec_helper'

module Foo
  class Bar; end
end

describe HappyMapper::Item do
  describe 'new instance' do
    before do
      @item = described_class.new(:foo, String, tag: 'foobar')
    end

    it 'accepts a name' do
      expect(@item.name).to eq('foo')
    end

    it 'accepts a type' do
      expect(@item.type).to eq(String)
    end

    it 'accepts :tag as an option' do
      expect(@item.tag).to eq('foobar')
    end

    it 'has a method_name' do
      expect(@item.method_name).to eq('foo')
    end
  end

  describe '#constant' do
    it 'justs use type if constant' do
      item = described_class.new(:foo, String)
      expect(item.constant).to eq(String)
    end

    it 'converts string type to constant' do
      item = described_class.new(:foo, 'String')
      expect(item.constant).to eq(String)
    end

    it 'converts string with :: to constant' do
      item = described_class.new(:foo, 'Foo::Bar')
      expect(item.constant).to eq(Foo::Bar)
    end
  end

  describe '#method_name' do
    it 'converts dashes to underscores' do
      item = described_class.new(:'foo-bar', String, tag: 'foobar')
      expect(item.method_name).to eq('foo_bar')
    end
  end

  describe '#xpath' do
    it 'defaults to tag' do
      item = described_class.new(:foo, String, tag: 'foobar')
      expect(item.xpath).to eq('foobar')
    end

    it 'prepends with .// if options[:deep] true' do
      item = described_class.new(:foo, String, tag: 'foobar', deep: true)
      expect(item.xpath).to eq('.//foobar')
    end

    it 'prepends namespace if namespace exists' do
      item = described_class.new(:foo, String, tag: 'foobar')
      item.namespace = 'v2'
      expect(item.xpath).to eq('v2:foobar')
    end
  end

  describe 'typecasting' do
    it 'works with Strings' do
      item = described_class.new(:foo, String)
      [21, '21'].each do |a|
        expect(item.typecast(a)).to eq('21')
      end
    end

    it 'works with Integers' do
      item = described_class.new(:foo, Integer)
      [21, 21.0, '21'].each do |a|
        expect(item.typecast(a)).to eq(21)
      end
    end

    it 'works with Floats' do
      item = described_class.new(:foo, Float)
      [21, 21.0, '21'].each do |a|
        expect(item.typecast(a)).to eq(21.0)
      end
    end

    it 'works with Times' do
      item = described_class.new(:foo, Time)
      expect(item.typecast('2000-01-01 01:01:01.123456')).to eq(Time.local(2000, 1, 1, 1, 1, 1, 123_456))
    end

    it 'works with Dates' do
      item = described_class.new(:foo, Date)
      expect(item.typecast('2000-01-01')).to eq(Date.new(2000, 1, 1))
    end

    it 'handles nil Dates' do
      item = described_class.new(:foo, Date)
      expect(item.typecast(nil)).to eq(nil)
    end

    it 'handles empty string Dates' do
      item = described_class.new(:foo, Date)
      expect(item.typecast('')).to eq(nil)
    end

    context 'with DateTime' do
      let(:item) { described_class.new(:foo, DateTime) }

      it 'works with a string' do
        result = item.typecast('2000-01-01 13:42:37')
        expect(result.to_time).to eq Time.new(2000, 1, 1, 13, 42, 37, '+00:00')
      end

      it 'works with a historical date in a string' do
        result = item.typecast('1616-04-23')
        expect(result.to_time).to eq Time.new(1616, 4, 23, 0, 0, 0, '+00:00')
        expect(result).to be_gregorian
      end

      it 'handles nil' do
        expect(item.typecast(nil)).to eq(nil)
      end

      it 'handles empty strings' do
        expect(item.typecast('')).to eq(nil)
      end
    end

    it 'works with Boolean' do
      item = described_class.new(:foo, HappyMapper::Boolean)
      expect(item.typecast('false')).to eq(false)
    end
  end
end
