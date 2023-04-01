class SuccessOutput < ApiOutput
  def format
    { message: message_success }
  end

  private

  def message_success
    @options[:message] ||= "Success"
  end
end
