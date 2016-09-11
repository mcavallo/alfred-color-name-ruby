# encoding: utf-8
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../vendor/gems/chunky_png/lib', __FILE__)
BASE_PATH = __dir__

require 'benchmark'
require 'name_that_color'

search = NameThatColor::ColorSearch.new

Benchmark.bmbm do |bm|
  bm.report do
    color = search.find(ARGV.first)
    puts color.valid? ? color.hex : 'INVALID'
  end
end
