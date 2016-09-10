# encoding: utf-8
# frozen_string_literal: true

require 'yaml'

module NameThatColor
  COLORS = YAML.load_file(File.join(BASE_PATH, 'assets', 'colors.yml'))
end
