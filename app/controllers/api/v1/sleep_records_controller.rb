class Api::V1::SleepRecordsController < ApplicationController
  def index
    #TODO paginate
    results = service.sleep_records
    render_json results
  end

  def clock_in
    result = service.clock_in
    render_json result,
                SuccessOutput,
                status: :created,
                message: "Successfully clock in!"
  end

  def clock_out
    result = service.clock_out
    render_json result,
                SuccessOutput,
                message: "Successfully clock out!"
  end

  private

  def service
    SleepRecordService.new(current_user)
  end
end
