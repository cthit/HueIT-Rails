require 'json'
class SseUpdateController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    change_int = Rails.application.config.sse_int
    while true do
      # If the int has changed we are told to update
      if change_int != Rails.application.config.sse_int
        change_int = Rails.application.config.sse_int
        lights = Huey::Bulb.all

        response.stream.write 'data: ' + lights.to_json + "\n\n"
      end
    end

    rescue IOError
      # Client Disconnected
    ensure
      response.stream.close
  end

end
