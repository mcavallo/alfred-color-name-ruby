# encoding: utf-8
# frozen_string_literal: true

require 'name_that_color/match'

module NameThatColor
  class ValidMatch < Match
    attr_reader :hex, :name, :rgb, :sass_variable, :sass_definition

    def initialize(hex_query, color_row, options = {})
      super(hex_query)
      @is_exact_match = options[:is_exact]
      set_color_properties(color_row)
    end

    def valid?
      true
    end

    def match_type
      exact? ? 'Exact' : 'Close match'
    end

    private

    def set_color_properties(color_row)
      @hex = '#' + color_row[0]
      @name = color_row[1]
      @r, @g, @b = color_row[2, 3]
      @h, @s, @l = color_row[5, 3]
      @sass_variable = to_sass_variable(@name)
      @sass_definition = "#{@sass_variable}: #{@hex};"
      @rgb = "rgb(#{@r}, #{@g}, #{@b});"
    end

    def to_sass_variable(name)
      '$color-' + name.downcase.gsub(/[^a-z]/, ' ').gsub(/\s+/, '-')
    end
  end
end
