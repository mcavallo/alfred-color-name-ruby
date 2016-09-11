# encoding: utf-8
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../vendor/gems/chunky_png/lib', __FILE__)
BASE_PATH = __dir__

require 'logger'
require 'alfred'
require 'name_that_color'
require 'icon'

logger = Logger.new(File.join(BASE_PATH, 'debug.log'))
logger.level = Logger::DEBUG
logger.datetime_format = ''

workflow = AlfredWorkflow.new
search = NameThatColor::ColorSearch.new(logger)
color = search.find(ARGV.first)

unless color.valid?
  workflow.send_result(
    valid: false,
    title: '?',
    subtitle: 'Invalid Color',
    mods: {
      alt: {
        subtitle: 'Invalid Color'
      },
      cmd: {
        subtitle: 'Invalid Color'
      },
      ctrl: {
        subtitle: 'Invalid Color'
      }
    }
  )
end

title_fmt = '%s (%s)'
subtitle_fmt = '%s ~ Copy: %s'

icon = Icon.new
icon_file = icon.create!(
  '/tmp/alfred-color-name',
  color.queried_hex,
  color.hex
)

workflow.send_result(
  arg: color.sass_variable,
  title: format(title_fmt, color.name, color.hex),
  subtitle: format(
    subtitle_fmt,
    color.match_type,
    color.sass_variable
  ),
  icon: {
    path: icon_file.path
  },
  mods: {
    alt: {
      arg: color.hex,
      subtitle: format(
        subtitle_fmt,
        color.match_type,
        color.hex
      )
    },
    cmd: {
      arg: color.rgb,
      subtitle: format(
        subtitle_fmt,
        color.match_type,
        color.rgb
      )
    },
    ctrl: {
      arg: color.sass_definition,
      subtitle: format(
        subtitle_fmt,
        color.match_type,
        color.sass_definition
      )
    }
  }
)
