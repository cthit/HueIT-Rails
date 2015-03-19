class LightsController < ApplicationController

	def index
		@client = Hue::Client.new

		@lights = @client.lights

#		client = Hue::Client.new

=begin
		for light in @lights
			light.set_state({
				:hue => [0,12750,36210,46920,56100].sample,
				:saturation => 254
				}, 0)
		end
=end
	end

	def edit

		client = Hue::Client.new

		#for light in client.lights
		#	light.set_state({
		#		:hue => [0,12750,36210,46920,56100].sample,
		#		:saturation => 254
		#		}, 0)
		#end
	end

	def new
		#@lights.sample.set_state({
		#	:hue => [0,12750,36210,46920,56100].sample,
		#	:saturation => 255}, 0)
		redirect_to(:action => 'index')
	end

	def create
		@client = Hue::Client.new

		@lights = @client.lights

		if (params[:newhue0].to_i != 0) then
			if (params[:newsat0].to_i != 0) then
				@lights[params[:id].to_i].set_state({
				:hue => params[:newhue0].to_i,
				:saturation => params[:newsat0].to_i}, 0)
			else
				@lights[params[:id].to_i].set_state({
				:hue => params[:newhue0].to_i}, 0)
			end
		else
			if (params[:newsat0].to_i != 0) then
				@lights[params[:id].to_i].set_state({
				:saturation => params[:newsat0].to_i}, 0)

			end
		end

		redirect_to(:action => 'index')

	end


	def show

	end

end
