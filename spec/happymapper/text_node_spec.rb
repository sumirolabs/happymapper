# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HappyMapper::TextNode do
  describe 'initialization' do
    before do
      @attr = described_class.new(:foo, String)
    end
  end
end
