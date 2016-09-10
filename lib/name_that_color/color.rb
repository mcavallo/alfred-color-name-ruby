# encoding: utf-8
# frozen_string_literal: true

module NameThatColor
  class Color
    attr_reader :hex, :name, :rgb, :sass_variable, :sass_definition

    def initialize(color_row)
      @hex = '#' + color_row[0]
      @name = color_row[1]
      @r = color_row[2]
      @g = color_row[3]
      @b = color_row[3]
      @h = color_row[4]
      @s = color_row[5]
      @l = color_row[6]
      @sass_variable = to_sass_variable @name
      @sass_definition = "#{@sass_variable}: #{@hex};"
      @rgb = "rgb(#{@r}, #{@g}, #{@b});"
    end

    private

    def to_sass_variable(name)
      '$color-' + name.downcase.gsub(/[^a-z]/, ' ').gsub(/\s+/, '-')
    end
  end
end
