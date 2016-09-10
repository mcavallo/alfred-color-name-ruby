# encoding: utf-8
# frozen_string_literal: true

require 'fileutils'
require 'chunky_png'

class Icon
  def initialize
    @png = ChunkyPNG::Image.new(32, 1, ChunkyPNG::Color::TRANSPARENT)
  end

  def create!(dest_path, left_color_hex, right_color_hex)
    prepare_directory(dest_path)
    generate_icon(left_color_hex, right_color_hex)
    @png.save(make_filename(dest_path), interlace: true)
  end

  private

  def generate_icon(left_color_hex, right_color_hex)
    left_color = ChunkyPNG::Color.from_hex(left_color_hex)
    right_color = ChunkyPNG::Color.from_hex(right_color_hex)
    half_width = @png.width / 2
    @png.width.times do |column|
      @png[column, 0] = column < half_width ? left_color : right_color
    end
  end

  def prepare_directory(dest_path)
    FileUtils.mkdir_p(dest_path) unless File.directory?(dest_path)
  end

  def make_filename(dest_path)
    File.join(dest_path, "#{Time.now.to_i}.png")
  end
end
