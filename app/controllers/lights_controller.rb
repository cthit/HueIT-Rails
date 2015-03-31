class LightsController < ApplicationController
	def index
    require 'huey'
    @lights = Huey::Bulb.all
    for light in @lights
      light.update(transitiontime: 0, 
                hue: [0, 12750, 36210, 46920, 56100].sample)
    end
  end

	def edit
    @light = Huey::Bulb.find(params[:id]) 
	end

	def show
    render plain: params[:id]
	end

end
