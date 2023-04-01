module HelpersForRequests
  def response_body
    JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include HelpersForRequests
end
