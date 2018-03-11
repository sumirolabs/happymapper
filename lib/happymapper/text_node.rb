# frozen_string_literal: true

module HappyMapper
  class TextNode < Item
    def find(node, _namespace, _xpath_options)
      yield(node.children.detect(&:text?))
    end
  end
end
