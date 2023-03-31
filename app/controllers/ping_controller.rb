class PingController < ApplicationController
  def index
    json_response({
      ping: "pong"
    })
  end
end
