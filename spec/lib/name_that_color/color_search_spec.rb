# encoding: utf-8
# frozen_string_literal: true

# Used to verify values:
# - Photoshop :)
# - http://www.rapidtables.com/convert/color/rgb-to-hsl.htm

require 'yaml'
require 'name_that_color'

describe NameThatColor::ColorSearch do
  subject do
    NameThatColor::ColorSearch.new(nil)
  end

  describe '#load_colors' do
    context 'with a provided array' do
      it 'should use the array for @colors' do
        colors = %w(000000 FFFFFF)
        subject.load_colors(colors)
        expect(subject.instance_variable_get(:@colors)).to eq(colors)
      end
    end

    context 'with a provided string' do
      it 'should load the YAML from the provided path' do
        path = 'whatever'
        allow(YAML).to receive(:load_file)
        expect(YAML).to receive(:load_file).with(path)
        subject.load_colors(path)
      end

      it 'should load @colors' do
        allow(YAML).to receive(:load_file).and_return(1)
        subject.load_colors('whatever')
        expect(subject.instance_variable_get(:@colors)).to eq(1)
      end
    end
  end

  describe '#validate_query' do
    before :each do
      subject.load_colors(%w(000000 FFFFFF))
      allow(subject).to receive(:format_query).and_return(1)
    end

    context 'with valid colors' do
      let :examples do
        ['111', 'f4f', 'ff66ff', 'd9d0a7', '9e9e9e', '#fff', '#ff0000']
      end

      it 'should not return false' do
        examples.each do |example|
          result = subject.send(:validate_query, example)
          expect(result).to eql(1)
        end
      end
    end

    context 'with invalid colors' do
      let :examples do
        ['1111', '', 'z', 'fffffff', '#3', '##']
      end

      it 'should return false' do
        examples.each do |example|
          result = subject.send(:validate_query, example)
          expect(result).to eql(false)
        end
      end
    end
  end

  describe '#format_query' do
    let :examples do
      [
        { input: '111', output: '111111' },
        { input: '#111', output: '111111' },
        { input: 'f4f', output: 'FF44FF' },
        { input: 'ff66ff', output: 'FF66FF' },
        { input: 'd9d0a7', output: 'D9D0A7' },
        { input: '9e9e9e', output: '9E9E9E' }
      ]
    end

    it 'should return the properly formatted colors' do
      examples.each do |example|
        result = subject.send(:format_query, example[:input])
        expect(result).to eql(example[:output])
      end
    end
  end

  describe '#color_diff' do
    it 'should sum rgb_proximity plus hsl_proximity * 2' do
      allow(subject).to receive(:rgb_proximity).and_return(1)
      allow(subject).to receive(:hsl_proximity).and_return(2)
      result = subject.send(:color_diff, 1, 2)
      expect(result).to eql(5)
    end
  end
end
