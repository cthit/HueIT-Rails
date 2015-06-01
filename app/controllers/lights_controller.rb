class LightsController < ApplicationController
	
	def index
    	@lights = Huey::Bulb.all
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
				@lights[params[:id].to_i-1].update(hue: params[:newhue0].to_i, 
                                         sat: params[:newsat0].to_i)
         # {
				#:hue => params[:newhue0].to_i,
				#:sat => params[:newsat0].to_i})
			else
				@lights[params[:id].to_i-1].set_state({
				:hue => params[:newhue0].to_i}, 0)
			end
		else
			if (params[:newsat0].to_i != 0) then
				@lights[params[:id].to_i-1].set_state({
				:saturation => params[:newsat0].to_i}, 0)

			end
		end

		redirect_to(:action => 'index')
	end

	def multi_update
		lights = params[:lights].keys

		lights.each do |light|
			bulb = Huey::Bulb.find light.to_i
			bulb.rgb = (params[:rgb][:color]).to_s
			bulb.save
		end	
		@lights = Huey::Bulb.all
		respond_to do |format|
			format.js
		end
	end

	def show
    	render plain: params[:id]
	end

	
	def turnOff
		@light = Huey::Bulb.find(params[:id].to_i)
		@light.update(on: false)
		@light.save
		redirect_to(:action => 'index')


	end

	def turnOn
		@light = Huey::Bulb.find(params[:id].to_i)
		@light.update(on: true)
		@light.save
		redirect_to(:action => 'index')
	end

	def switchOnOff
		@light = Huey::Bulb.find(params[:id].to_i)
		@light.on = !@light.on
		@light.save
		redirect_to(:action => 'index')
	end
end
