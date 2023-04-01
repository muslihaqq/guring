class PingController < ApplicationController
  def index
    ping = { ping: "pong" }
    render_json ping
  end
end
