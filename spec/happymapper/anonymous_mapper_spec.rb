# frozen_string_literal: true

RSpec.describe HappyMapper::AnonymousMapper do
  let(:anonymous_mapper) { described_class.new }

  describe '#parse' do
    context 'when parsing a single root node' do
      let(:parsed_result) { anonymous_mapper.parse fixture_file('address.xml') }

      it 'parses child elements' do
        aggregate_failures do
          expect(parsed_result.street).to eq('Milchstrasse')
          expect(parsed_result.housenumber).to eq('23')
          expect(parsed_result.postcode).to eq('26131')
          expect(parsed_result.city).to eq('Oldenburg')
        end
      end

      it 'does not create a content entry when the xml contents no text content' do
        expect(parsed_result).not_to respond_to :content
      end

      it 'parses both the attributes and content when present' do
        aggregate_failures do
          expect(parsed_result.country.code).to eq('de')
          expect(parsed_result.country.content).to eq('Germany')
        end
      end
    end

    context 'with element names with special characters' do
      let(:parsed_result) { anonymous_mapper.parse fixture_file('ambigous_items.xml') }

      it 'creates accessor methods with similar names' do
        expect(parsed_result.my_items.item).to be_kind_of Array
      end
    end

    context 'with element names with camelCased elements and Capital Letters' do
      let(:parsed_result) { anonymous_mapper.parse fixture_file('subclass_namespace.xml') }

      it 'parses camel-cased child elements correctly' do
        aggregate_failures do
          expect(parsed_result.photo.publish_options.author).to eq('Stephanie')
          expect(parsed_result.gallery.photo.title).to eq('photo title')
        end
      end

      it 'parses camel-cased child properties correctly' do
        expect(parsed_result.publish_options.created_day).to eq('2011-01-14')
      end
    end

    context 'with elements with camelCased attribute names' do
      let(:parsed_result) { anonymous_mapper.parse '<foo barBaz="quuz"/>' }

      it 'parses attributes correctly' do
        expect(parsed_result.bar_baz).to eq('quuz')
      end
    end

    context 'with several elements nested deeply' do
      let(:parsed_result) { anonymous_mapper.parse fixture_file('ambigous_items.xml') }

      it 'parses the entire relationship' do
        expect(parsed_result.my_items.item.first.item.name).to eq('My first internal item')
      end
    end

    context 'when parsing xml that contains multiple entries' do
      let(:parsed_result) { anonymous_mapper.parse fixture_file('multiple_primitives.xml') }

      it "parses the elements as it would a 'has_many'" do
        aggregate_failures do
          expect(parsed_result.name).to eq('value')
          expect(parsed_result.image).to eq(%w(image1 image2))
        end
      end
    end

    context 'when parsing xml with multiple namespaces' do
      let(:parsed_result) { anonymous_mapper.parse fixture_file('subclass_namespace.xml') }

      it 'parses the elements an values correctly' do
        expect(parsed_result.title).to eq('article title')
      end

      it 'parses attribute names correctly' do
        expect(parsed_result.name).to eq 'title'
      end
    end

    context 'with value elements with different namespace' do
      let(:xml) do
        <<~XML
          <a:foo xmlns:a="http://foo.org/a" xmlns:b="http://foo.org/b">
            <b:bar>Hello</b:bar>
          </a:foo>
        XML
      end
      let(:result) { anonymous_mapper.parse xml }

      it 'parses the value elements correctly' do
        expect(result.bar).to eq 'Hello'
      end
    end
  end
end
