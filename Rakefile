# encoding: utf-8
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
BASE_PATH = __dir__

Dir.glob('lib/tasks/**/*.rake').each { |r| import r }

task :default do
  system 'rake -T'
end
