# encoding: utf-8
# frozen_string_literal: true

require 'csv'
require 'yaml'
require 'color_utils'

class ColorGenerator
  def initialize(source_file:, output_file:)
    @data = []
    @source_file = source_file
    @output_file = output_file
  end

  def run
    read_csv_source
    save_yaml_output
  end

  private

  def format_csv_row(csv_row)
    [csv_row.first, csv_row.last]
      .concat(ColorUtils.color_components(csv_row.first))
  end

  def read_csv_source
    CSV.foreach(@source_file, quote_char: '"') do |csv_row|
      @data << format_csv_row(csv_row)
    end
  end

  def save_yaml_output
    File.open(@output_file, 'w') do |f|
      f.write "# Hands off! File generated by rake task\n"
      f.write @data.to_yaml
    end
  end
end