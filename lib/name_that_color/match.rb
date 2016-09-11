# encoding: utf-8
# frozen_string_literal: true

module NameThatColor
  class Match
    def initialize(hex_query)
      @query = hex_query
      @is_exact_match = false
    end

    def queried_hex
      '#' + @query
    end

    def valid?
    end

    def exact?
      @is_exact_match
    end
  end
end
