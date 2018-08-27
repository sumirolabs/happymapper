# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'after_parse callbacks' do
  module AfterParseSpec
    class Address
      include HappyMapper
      element :street, String
    end
  end

  after do
    AfterParseSpec::Address.after_parse_callbacks.clear
  end

  it 'callbacks with the newly created object' do
    from_cb = nil
    called = false
    cb1 = proc { |object| from_cb = object }
    cb2 = proc { called = true }
    AfterParseSpec::Address.after_parse(&cb1)
    AfterParseSpec::Address.after_parse(&cb2)

    object = AfterParseSpec::Address.parse fixture_file('address.xml')
    expect(from_cb).to eq(object)
    expect(called).to eq(true)
  end
end
