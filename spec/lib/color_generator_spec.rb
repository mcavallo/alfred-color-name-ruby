# encoding: utf-8
# frozen_string_literal: true

require 'color_utils'
require 'color_generator'

describe ColorGenerator do
  subject do
    ColorGenerator.new(
      source_file: 'path/a',
      output_file: 'path/b'
    )
  end

  describe '#initialize' do
    it 'should initialize empty data and save file paths' do
      expect(subject.instance_variable_get(:@source_file)).to eq('path/a')
      expect(subject.instance_variable_get(:@output_file)).to eq('path/b')
      expect(subject.instance_variable_get(:@data)).to eq([])
    end
  end

  describe '#run' do
    before(:each) do
      allow(subject).to receive(:read_csv_source)
      allow(subject).to receive(:save_yaml_output)
    end

    it 'should read the csv' do
      expect(subject).to receive(:read_csv_source)
      subject.run
    end

    it 'should write the yaml' do
      expect(subject).to receive(:save_yaml_output)
      subject.run
    end
  end

  describe '#format_csv_row' do
    it 'should return a complete row with rgb and hsl' do
      example = ['000000', 'Black', 0, 0, 0, 0, 0]
      allow(ColorUtils).to receive(:color_components).with(example.first).and_return(example[2..-1])
      row = subject.send(:format_csv_row, example[0..1])
      expect(row).to eql(example)
    end
  end

  describe '#read_csv_source' do
    let :csv_data do
      [%w(000000 Black), %w(FFFFFF White)]
    end

    before :each do
      allow(CSV).to receive(:foreach)
        .and_yield(csv_data.first)
        .and_yield(csv_data.last)
      allow(subject).to receive(:format_csv_row) { |arg| arg }
    end

    it 'populate @data with the csv rows' do
      subject.send(:read_csv_source)
      expect(subject.instance_variable_get(:@data)).to eq(csv_data)
    end
  end
end
