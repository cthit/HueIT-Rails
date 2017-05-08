require 'json'
class SseUpdateController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'

    lights = Huey::Bulb.all

    response.stream.write 'data: ' + {lights: lights, isPartyOn: $is_party_on}.to_json + "\n\n"

    rescue IOError
      # Client Disconnected
    ensure
      response.stream.close
  end

end
