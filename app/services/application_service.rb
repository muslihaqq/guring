class ApplicationService
  def exist!(object, on_error: "Not Found")
    raise NotFound, on_error if object.nil?
  end

  def assert!(truth, on_error: "Invalid")
    raise Invalid, on_error if truth
  end

  def authorize!(permission, on_error: "Invalid")
    raise NotAuthorized, on_error if permission.nil?
  end

  class NotFound < ActiveRecord::RecordNotFound
  end

  class Invalid < ApplicationController::Invalid
  end

  class NotAuthorized < ApplicationController::NotAuthorized
  end
end
