# encoding: utf-8
# frozen_string_literal: true

# Used to verify values:
# - Photoshop :)
# - http://www.rapidtables.com/convert/color/rgb-to-hsl.htm

require 'color_utils'

describe ColorUtils do
  let :examples do
    [{
      color: 'FFFFFF',
      eight_bit: [255, 255, 255],
      factional: [1.0, 1.0, 1.0],
      hsl: [0, 0.0, 100.0]
    }, {
      color: '000000',
      eight_bit: [0, 0, 0],
      factional: [0.0, 0.0, 0.0],
      hsl: [0, 0.0, 0.0]
    }, {
      color: 'F4F4F4',
      eight_bit: [244, 244, 244],
      factional: [0.9568627450980393, 0.9568627450980393, 0.9568627450980393],
      hsl: [0, 0.0, 95.69]
    }, {
      color: 'FF44FF',
      eight_bit: [255, 68, 255],
      factional: [1.0, 0.26666666666666666, 1.0],
      hsl: [300, 100.0, 63.33]
    }, {
      color: '672020',
      eight_bit: [103, 32, 32],
      factional: [0.403921568627451, 0.12549019607843137, 0.12549019607843137],
      hsl: [0, 52.59, 26.47]
    }, {
      color: '68B4A5',
      eight_bit: [104, 180, 165],
      factional: [0.40784313725490196, 0.7058823529411765, 0.6470588235294118],
      hsl: [168, 33.63, 55.69]
    }, {
      color: '8459DF',
      eight_bit: [132, 89, 223],
      factional: [0.5176470588235295, 0.34901960784313724, 0.8745098039215686],
      hsl: [259, 67.68, 61.18]
    }]
  end

  describe '#color_components' do
    it 'should a color row with [r, g, b, h, s, l] format' do
      allow(ColorUtils).to receive(:rgb_8bit_components).and_return([1, 2, 3])
      allow(ColorUtils).to receive(:hsl_components).and_return([4, 5, 6])
      result = ColorUtils.color_components('whatever')
      expect(result).to eql([1, 2, 3, 4, 5, 6])
    end

    it 'should return proper results from rgb_8bit_components + hsl_components' do
      examples.each do |example|
        result = ColorUtils.color_components(example[:color])
        expect(result).to eq(example[:eight_bit].concat(example[:hsl]))
      end
    end
  end

  describe '#rgb_8bit_components' do
    it 'should return the 3 RGB 8bit components' do
      examples.each do |example|
        result = ColorUtils.rgb_8bit_components(example[:color])
        expect(result).to eq(example[:eight_bit])
      end
    end
  end

  describe '#rgb_fractional_components' do
    it 'should return the 3 RGB fractional components' do
      examples.each do |example|
        result = ColorUtils.rgb_fractional_components(example[:color])
        expect(result).to eq(example[:factional])
      end
    end
  end

  describe '#hsl_components' do
    it 'should return the 3 HSL components' do
      examples.each do |example|
        result = ColorUtils.hsl_components(example[:color])
        expect(result).to eq(example[:hsl])
      end
    end
  end

  describe '#hsl_formatting' do
    it 'should return HSL components with proper formatting' do
      result = ColorUtils.hsl_formatting(100.5, 0.104999, 0.544444)
      expect(result).to eq([101, 10.50, 54.44])
    end
  end
end
