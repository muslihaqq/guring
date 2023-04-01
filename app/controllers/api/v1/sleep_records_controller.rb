class Api::V1::SleepRecordsController < ApplicationController
  before_action :set_friend, only: :friend_records
 
  def index
    #TODO paginate
    @records = @current_user.sleep_records.complete
    json_response({ data: @records })
  end

  def clock_in
    if @current_user.clock_in!
      json_response({ message: "Successfully clock in!" })
    else
      json_response({
        error: "Unable to clock in"
      })
    end
  end

  def clock_out
    @incomplete_clock_out = @current_user.sleep_records.incomplete.last

    return json_response({ error: "Theres no incomplete record" }) if @incomplete_clock_out.nil?
  
    if @current_user.clock_out!
      json_response({ message: "Successfully clock out!" })
    else
      json_response({
        error: "Unable to clock out"
      })
    end
  end

  private
  def set_friend
    @friend = User.find(params[:friend_id])
  end
end
