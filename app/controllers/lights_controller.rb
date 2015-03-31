class LightsController < ApplicationController
	def index
   # require 'huey'
    @lights = Huey::Bulb.all
   # for light in @lights
   #   light.update(transitiontime: 0, 
   #             hue: [0, 12750, 36210, 46920, 56100].sample)
   # end
  end

	def edit
    @light = Huey::Bulb.find(params[:id]) 

		for light in @lights
			light.set_state({
				:hue => [0,12750,36210,46920,56100].sample,
				:saturation => 254
				}, 0)
		end
	end


	def new
		#@lights.sample.set_state({
		#	:hue => [0,12750,36210,46920,56100].sample,
		#	:saturation => 255}, 0)
		redirect_to(:action => 'index')
	end

	def create

    @lights = Huey::Bulb.all

		if (params[:newhue0].to_i != 0) then
			if (params[:newsat0].to_i != 0) then
				@lights[params[:id].to_i].update(hue: params[:newhue0].to_i, 
                                         sat: params[:newsat0].to_i)
         # {
				#:hue => params[:newhue0].to_i,
				#:sat => params[:newsat0].to_i})
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
    render plain: params[:id]
	end

end
