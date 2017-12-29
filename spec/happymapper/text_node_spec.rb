# frozen_string_literal: true

require 'spec_helper'

describe HappyMapper::Attribute do
  describe 'initialization' do
    before do
      @attr = HappyMapper::TextNode.new(:foo, String)
    end
  end
end
