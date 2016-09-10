# encoding: utf-8
# frozen_string_literal: true

require 'json'

class AlfredWorkflow
  def initialize
    @output = {
      items: []
    }
  end

  def add_item(new_item)
    @output[:items] << new_item
  end

  def override(new_item)
    @output[:items] = [new_item]
  end

  def terminate
    puts @output.to_json
    exit 0
  end

  def send_result(new_item)
    add_item new_item
    terminate
  end
end
