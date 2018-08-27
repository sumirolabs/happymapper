# frozen_string_literal: true

require 'spec_helper'

describe HappyMapper::Element do
  describe 'initialization' do
    before do
      @attr = described_class.new(:foo, String)
    end
  end
end
