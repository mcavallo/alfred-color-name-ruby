# encoding: utf-8
# frozen_string_literal: true

require 'color_utils'

module NameThatColor
  class ColorQuery
    attr_reader :match

    def initialize(hex_query, logger)
      @logger = logger
      @is_valid = false
      @is_exact_match = false
      @match = nil
      check_for_valid_query(hex_query)
      find_color if valid?
    end

    def valid?
      @is_valid
    end

    def exact?
      @is_exact_match
    end

    def match_type
      exact? ? 'Exact' : 'Close match'
    end

    def queried_hex
      '#' + @queried
    end

    private

    def check_for_valid_query(hex_query)
      return false unless hex_query =~ /^#?([a-f0-9]{6}|[a-f0-9]{3})\b$/i
      @queried = format_query(hex_query)
      @queried_row = [@queried, '???'].concat(::ColorUtils.color_components(@queried))
      @is_valid = true
    end

    def format_query(hex_query)
      hex_query = hex_query.gsub(/^#/, '').upcase
      hex_query.chars.map! { |c| "#{c}" * 2 }.join if hex_query.length == 3
    end

    def find_color
      closest = nil
      closest_color = nil
      COLORS.each do |color_row|
        diff = color_diff(@queried_row, color_row)
        if diff.zero?
          closest = diff
          closest_color = color_row
          break
        end
        next if closest && diff > closest
        closest = diff
        closest_color = color_row
      end
      make_match(color: closest_color, is_exact: closest.zero? ? true : false)
    end

    def compare_color(queried_row, color_row)
      return 0 if queried_row[0] == color_row[0]
      color_diff(queried_row, color_row)
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

    def make_match(color: nil, is_exact: false)
      @match = Color.new(color)
      @is_exact_match = is_exact
    end
  end
end
