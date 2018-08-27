# frozen_string_literal: true

RSpec.describe HappyMapper::AnonymousMapper do
  let(:anonymous_mapper) { described_class.new }

  describe '#parse' do
    context 'on a single root node' do
      subject { anonymous_mapper.parse fixture_file('address.xml') }

      it 'parses child elements' do
        expect(subject.street).to eq('Milchstrasse')
        expect(subject.housenumber).to eq('23')
        expect(subject.postcode).to eq('26131')
        expect(subject.city).to eq('Oldenburg')
      end

      it 'does not create a content entry when the xml contents no text content' do
        expect(subject).not_to respond_to :content
      end

      context 'child elements with attributes' do
        it 'parses the attributes' do
          expect(subject.country.code).to eq('de')
        end

        it 'parses the content' do
          expect(subject.country.content).to eq('Germany')
        end
      end
    end

    context 'element names with special characters' do
      subject { anonymous_mapper.parse fixture_file('ambigous_items.xml') }

      it 'creates accessor methods with similar names' do
        expect(subject.my_items.item).to be_kind_of Array
      end
    end

    context 'element names with camelCased elements and Capital Letters' do
      subject { anonymous_mapper.parse fixture_file('subclass_namespace.xml') }

      it 'parses camel-cased child elements correctly' do
        expect(subject.photo.publish_options.author).to eq('Stephanie')
        expect(subject.gallery.photo.title).to eq('photo title')
      end

      it 'parses camel-cased child properties correctly' do
        expect(subject.publish_options.created_day).to eq('2011-01-14')
      end
    end

    context 'with elements with camelCased attribute names' do
      subject { anonymous_mapper.parse '<foo barBaz="quuz"/>' }

      it 'parses attributes correctly' do
        expect(subject.bar_baz).to eq('quuz')
      end
    end

    context 'several elements nested deep' do
      subject { anonymous_mapper.parse fixture_file('ambigous_items.xml') }

      it 'parses the entire relationship' do
        expect(subject.my_items.item.first.item.name).to eq('My first internal item')
      end
    end

    context 'xml that contains multiple entries' do
      subject { anonymous_mapper.parse fixture_file('multiple_primitives.xml') }

      it "parses the elements as it would a 'has_many'" do
        expect(subject.name).to eq('value')
        expect(subject.image).to eq(%w(image1 image2))
      end
    end

    context 'xml with multiple namespaces' do
      subject { anonymous_mapper.parse fixture_file('subclass_namespace.xml') }

      it 'parses the elements an values correctly' do
        expect(subject.title).to eq('article title')
      end

      it 'parses attribute names correctly' do
        expect(subject.name).to eq 'title'
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
