# encoding: utf-8
# frozen_string_literal: true

require 'color_utils'
require 'name_that_color/invalid_match'
require 'name_that_color/valid_match'

module NameThatColor
  class ColorSearch
    def initialize(logger = nil)
      @logger = logger
    end

    def find(hex_query)
      query = validate_query(hex_query)
      return InvalidMatch.new(query) unless query
      perform_search(query)
    end

    private

    def validate_query(hex_query)
      return false unless hex_query =~ /^#?([a-f0-9]{6}|[a-f0-9]{3})\b$/i
      format_query(hex_query)
    end

    def format_query(hex_query)
      hex_query = hex_query.gsub(/^#/, '').upcase
      hex_query.chars.map! { |c| c.to_s * 2 }.join if hex_query.length == 3
    end

    def perform_search(query)
      exact_match = find_exact_match(COLORS, query)
      return ValidMatch.new(query, exact_match, is_exact: true) if exact_match
      ValidMatch.new(query, find_closest_match(COLORS, query), is_exact: false)
    end

    def find_exact_match(list, query)
      return list.first[0] == query ? list.first : nil if list.length == 1
      find_exact_match(select_list_half(list, query), query)
    end

    def select_list_half(list, query)
      half = (list.length / 2).floor
      list[half][0] > query ? list[0, half] : list[half, list.length]
    end

    def find_closest_match(list, query)
      closest_score = nil
      closest_color = nil
      query_row = ::ColorUtils.color_row(query, nil)
      list.each do |color_row|
        diff = color_diff(query_row, color_row)
        next if closest_score && diff > closest_score
        closest_score = diff
        closest_color = color_row
      end
      closest_color
    end

    def color_diff(row_a, row_b)
      rgb_proximity(row_a, row_b) + hsl_proximity(row_a, row_b) * 2
    end

    def hsl_proximity(row_a, row_b)
      (row_a[5] - row_b[5])**2 +
        (row_a[6] - row_b[6])**2 +
        (row_a[7] - row_b[7])**2
    end

    def rgb_proximity(row_a, row_b)
      (row_a[2] - row_b[2])**2 +
        (row_a[3] - row_b[3])**2 +
        (row_a[4] - row_b[4])**2
    end
  end
end
