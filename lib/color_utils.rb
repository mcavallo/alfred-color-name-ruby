# encoding: utf-8
# frozen_string_literal: true

module ColorUtils
  def self.color_components(color)
    result = rgb_8bit_components(color)
    result.concat(hsl_components(color))
  end

  def self.rgb_8bit_components(color)
    color.scan(/../).map(&:hex)
  end

  def self.rgb_fractional_components(color)
    color.scan(/../).map { |part| part.hex.to_f / 255 }
  end

  # source: http://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
  def self.hsl_components(color)
    r, g, b = rgb_fractional_components(color)
    min = [r, g, b].min
    max = [r, g, b].max
    l = (max + min) / 2.0
    return hsl_formatting(0, 0, l) unless max != min
    diff = max - min
    s = saturation_value(l, min, max, diff)
    h = hue_value(r, g, b, max, diff)
    h = (h / 6) * 360
    hsl_formatting(h, s, l)
  end

  def self.saturation_value(lightness, min, max, diff)
    lightness > 0.5 ? diff / (2.0 - max - min) : diff / (max + min)
  end

  def self.hue_value(r, g, b, max, diff)
    case max
    when r
      (g - b) / diff + (g < b ? 6 : 0)
    when g
      (b - r) / diff + 2.0
    else
      (r - g) / diff + 4.0
    end
  end

  def self.hsl_formatting(h, s, l)
    [h.round, (s * 100).round(2), (l * 100).round(2)]
  end
end
