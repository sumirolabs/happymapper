# frozen_string_literal: true

require 'spec_helper'

module Amazing
  class Baby
    include HappyMapper

    has_one :name, String
  end

  class Item
    include HappyMapper

    tag 'item'
    namespace 'amazing'

    element :title, String
    attribute :link, String, xpath: 'amazing:link/@href'
    has_one :different_link, String, xpath: 'different:link/@href'
    element :detail, String, xpath: 'amazing:subitem/amazing:detail'
    has_many :more_details_text, String, xpath: 'amazing:subitem/amazing:more'
    has_many :more_details, String,
             xpath: 'amazing:subitem/amazing:more/@first|amazing:subitem/amazing:more/@alternative'
    has_many :more_details_alternative, String, xpath: 'amazing:subitem/amazing:more/@*'

    has_one :baby, Baby, namespace: 'amazing'
  end
end

RSpec.describe 'Specifying elements and attributes with an xpath', type: :feature do
  let(:parsed_result) { Amazing::Item.parse(xml_string, single: true) }

  let(:xml_string) do
    <<~XML
      <rss>
        <amazing:item xmlns:amazing="http://www.amazing.com/amazing"
                      xmlns:different="http://www.different.com/different">
          <amazing:title>Test XML</amazing:title>
          <different:link href="different_link" />
          <amazing:link href="link_to_resources" />
          <amazing:subitem>
            <amazing:detail>I want to parse this</amazing:detail>
            <amazing:more first="this one">more 1</amazing:more>
            <amazing:more alternative="another one">more 2</amazing:more>
          </amazing:subitem>
          <amazing:baby>
            <amazing:name>Jumbo</amazing:name>
          </amazing:baby>
        </amazing:item>
      </rss>
    XML
  end

  it 'has a title' do
    expect(parsed_result.title).to eq 'Test XML'
  end

  it 'finds the link href value' do
    expect(parsed_result.link).to eq 'link_to_resources'
  end

  it 'finds the other link href value' do
    expect(parsed_result.different_link).to eq 'different_link'
  end

  it 'finds this subitem based on the xpath' do
    expect(parsed_result.detail).to eq 'I want to parse this'
  end

  it 'finds the subitem texts based on the xpath' do
    expect(parsed_result.more_details_text).to eq ['more 1', 'more 2']
  end

  it 'finds the subitem attributes based on the xpath' do
    expect(parsed_result.more_details).to eq ['this one', 'another one']
  end

  it 'finds the subitem attributes based on the xpath with a wildcard' do
    expect(parsed_result.more_details_alternative).to eq ['this one', 'another one']
  end

  it 'has a baby name' do
    expect(parsed_result.baby.name).to eq 'Jumbo'
  end
end
