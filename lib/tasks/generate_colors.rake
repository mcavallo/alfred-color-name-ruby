# encoding: utf-8
# frozen_string_literal: true

require 'color_generator'

desc 'Turns the colors.csv into colors definition'
task :generate_colors do
  ColorGenerator.new(
    source_file: File.join(BASE_PATH, 'assets', 'colors.csv'),
    output_file: File.join(BASE_PATH, 'assets', 'colors.yml')
  ).run
end
