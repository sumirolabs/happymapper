# frozen_string_literal: true

require "spec_helper"

RSpec.describe HappyMapper::ClassMethods do
  let(:klass) do
    Class.new.tap do |cls|
      cls.extend described_class
    end
  end

  describe "#tag" do
    it "does not allow namespace to be included" do
      expect { klass.tag "foo:bar" }.to raise_error HappyMapper::SyntaxError
    end
  end
end
