# frozen_string_literal: true

class ApiOutput
  def initialize(object, options = {})
    @object = object
    @options = options
  end

  def format
    @object.as_json
  end
end
