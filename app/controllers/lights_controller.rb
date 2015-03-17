class LightsController < ApplicationController

	def index
		@client = Hue::Client.new

		@lights = @client.lights

#		client = Hue::Client.new

		for light in @lights
			light.set_state({
				:hue => [0,12750,36210,46920,56100].sample,
				:saturation => 254
				}, 0)
		end
	end

	def edit
		client = Hue::Client.new

		for light in client.lights
			light.set_state({
				:hue => [0,12750,36210,46920,56100].sample,
				:saturation => 254
				}, 0)
		end
	end

	def show

	end

end
