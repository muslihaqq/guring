class Api::V1::SleepRecordsController < ApplicationController
  def index
    sleep_records = service.sleep_records
    pagy, results = pagy(sleep_records, items: limit)
    render_json_array results,
                      metadata: pagy_metadata(pagy)
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
