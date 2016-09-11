# encoding: utf-8
# frozen_string_literal: true

require 'name_that_color/match'

module NameThatColor
  class InvalidMatch < Match
    def valid?
      false
    end
  end
end
