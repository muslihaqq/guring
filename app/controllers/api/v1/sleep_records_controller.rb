class Api::V1::SleepRecordsController < ApplicationController
  def index
    #TODO paginate
    @records = @user.sleep_records.complete
    json_response({ data: @records })
  end

  def clock_in
    if @user.clock_in!
      json_response({ message: "Successfully clock in!" })
    else
      json_response({
        error: "Unable to clock in"
      })
    end
  end

  def clock_out
    @incomplete_clock_out = @user.sleep_records.incomplete.last

    return json_response({ error: "Theres no incomplete record" }) if @incomplete_clock_out.nil?
  
    if @user.clock_out!
      json_response({ message: "Successfully clock out!" })
    else
      json_response({
        error: "Unable to clock out"
      })
    end
  end
end
