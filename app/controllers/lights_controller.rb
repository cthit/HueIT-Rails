class LightsController < ApplicationController
	include AdminHelper

	before_action :check_lock_state, except: [:index]
	before_action :check_party, except: [:index, :party_on_off, :party_off, :party_on]

	def change_logger
		@@change_logger ||= Logger.new("#{Rails.root}/log/change.log")
	end


#Creates sites
	def index
		begin
			@lights = Huey::Bulb.all
			@is_locked = check_lock_state

		rescue Huey::Errors::CouldNotFindHue
			
		end
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
#Changes lights
	def multi_update
		if params[:lights]
			lights = params[:lights].keys

			@changedLights = ""

			lights.each do |light|
				bulb = Huey::Bulb.find light.to_i
				if bulb.on
					bulb.update(sat: (params[:sat_range]).to_i, hue: (params[:hue_range].to_i), bri: (params[:bri_range].to_i))
					bulb.save
					@changedLights += light.to_s+" "
				end
			end

			#@user = User.find_by_token cookies[:chalmersItAuth]
			#change_logger.info "#{@user.cid}: Lamps ##{@changedLights}values changed to hue:#{(params[:hue_range]).to_s} sat: #{(params[:sate_range]).to_s} bri: #{(bri_range]).to_s}"
			log "Lamps ##{@changedLights}color changed to hue:#{(params[:hue_range]).to_s} sat: #{(params[:sate_range]).to_s} bri: #{(params[:bri_range]).to_s}"
			sse_update
		end
		@lights = Huey::Bulb.all
		respond_to do |format|
			format.js
		end

	end
#shows a specific lamp (lights/1)
	def show
		render plain: params[:id]
	end
#Set standard light
	def reset_lights
		lights = Huey::Bulb.all

		lights.each do |light|
			if light.on 
				light.update(rgb: '#cff974', bri: 200)
				light.save
			end
		end

		#@user = User.find_by_token cookies[:chalmersItAuth]
		#change_logger.info "#{@user.cid}: All lamps reset"
		log("All lamps reset")
		sse_update
		@lights = Huey::Bulb.all
		respond_to do |format|
			format.js
		end
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

	def turn_all_off
		lights_group = Huey::Group.new(Huey::Bulb.find(1),Huey::Bulb.find(2),Huey::Bulb.find(3),
			Huey::Bulb.find(4), Huey::Bulb.find(5), Huey::Bulb.find(6))

		lights_group.update(on: false, transitiontime: 0)

		log("All lights OFF")
		sse_update
		@lights = Huey::Bulb.all
		respond_to do |format|
			format.js
		end
	end

	def turn_all_on
		lights_group = Huey::Group.new(Huey::Bulb.find(1),Huey::Bulb.find(2),Huey::Bulb.find(3),
			Huey::Bulb.find(4), Huey::Bulb.find(5), Huey::Bulb.find(6))

		lights_group.update(on: true, transitiontime: 0)

		log("All lights ON")
		sse_update
		@lights = Huey::Bulb.all
		respond_to do |format|
			format.js
		end
	end
#Toggles light state
	def switchOnOff
		@light = Huey::Bulb.find(params[:id].to_i)
		@light.on = !@light.on
		@light.save
		log("Lamp ##{params[:id]} toggled")
	end

	def party_on_off
		if Rails.application.config.is_party_on
			party_off
		else
			party_on
		end
	end
	
	private
	def log(change)
		entry = LogEntry.new
		@user = User.find_by_token cookies[:chalmersItAuth]
		entry.cid = @user.cid + ": " + @user.to_s
		entry.change = change
		entry.save
		entry 
	end

	def party_on
		entry = log("PARTY MODE ENGAGED :DDDDD")
		Rails.application.config.is_party_on = true

		Thread.new do 
			lights = Huey::Bulb.all

			hue_array = Array.new
			sat_array = Array.new
			bri_array = Array.new

			lights.each_with_index do |light, i|
				hue_array[i] = light.hue 
				sat_array[i] = light.sat
				bri_array[i] = light.bri
			end
			sse_update
			while Rails.application.config.is_party_on
				# Loop that runs indefinitely until something else is logged
					   i = [1,2,3,4,5].sample
	   
	   if i == 1 then
	      # Randoms bulb and color 
	      light = lights.sample
	      if light.on then 
	         light.update(hue: [0, 5000, 15000, 20000, 42000, 55000, 62000].sample, 
	            sat: [255].sample, bri: 255, transitiontime: 0) 
	         light.save  
	         sleep(0.2)
	      end
	   elsif i == 2 then
	      # Pattern that shifts one color down the lights. 
	      color = [0, 5000, 15000, 20000, 42000, 55000, 62000].sample
	      prev_color = 0
	      lights.each_with_index do |light, i|
	         if (i-1) >= 0 && lights[i-1].on then
	            lights[i-1].update(hue: prev_color)
	            lights[i-1].save
	         end
	         if light.on then
	            prev_color = light.hue
	            light.update(hue: color, sat: 255, bri: 255)
	            light.save
	            sleep(0.2)
	         end
	      end
	      if lights[5].on then
	         lights[5].update(hue: prev_color)
	         lights[5].save
	         sleep(0.2)
	      end
	   elsif i == 3 then
	      # Pattern that shifts one color down both lanes
	      color = [0, 5000, 15000, 20000, 42000, 55000, 62000].sample
	      prev_color_1 = 0
	      prev_color_2 = 0
	      for i in 0..2
	         if (i-1) >= 0 then
	            lights_group_prev = Huey::Group.new(lights[i-1], lights[i+2])
	            if lights[i-1].on then
	               lights[i-1].update(hue: prev_color_1)
	            end
	            if lights[i+2] then 
	               lights[i+2].update(hue: prev_color_2)
	            end
	            # might have to save them separetely
	            lights_group_prev.save
	         end

	         lights_group_now = Huey::Group.new(lights[i], lights[i+3])
	         if lights[1].on then 
	            prev_color_1 = lights[i].hue
	         end
	         if lights[i+3] then
	            prev_color_2 = lights[i+3].hue
	         end

	         lights_group_now.update(hue: color, sat: 255, bri: 255, transitiontime: 0)
	         sleep(0.2)
	      end
	      
	      if lights[2].on && lights[5].on then 
	         lights_group = Huey::Group.new(lights[2], lights[5])
	         lights[2].update(hue: prev_color_1)
	         lights[5].update(hue: prev_color_2)
	         lights_group.save 
	         sleep(0.2)
	      end
	   elsif i == 4 then
	      # Blink all bulbs in same color
	      color = [0, 5000, 15000, 20000, 42000, 55000, 62000].sample

	      lights_group = Huey::Group.new(Huey::Bulb.all)
	      lights_group.update(hue: color)
	      sleep(0.2)
	   

	   elsif i == 5 then
	      # Randoms all bulbs in order
	      lights.each do |light| 
	         if light.on then 
	            light.update(hue: [0, 1000, 10000, 15000, 20000, 45000, 55000, 62000].sample, 
	               sat: [200, 255].sample, bri: 255, transitiontime: 0) 
	            light.save  
	            sleep(0.2)
	         end
	      end

	   else
	      # Randoms bulb and color 
	      light = lights.sample
	      if light.on then
	         light.update(hue: [0, 5000, 15000, 20000, 42000, 55000, 62000].sample, 
	            sat: [255].sample, bri: 255, transitiontime: 0) 
	         light.save  
	         sleep(0.2)
	      end
	   end
			end
			sse_update
			lights.each_with_index do |light, i|
				light.update(sat: sat_array[1], hue: hue_array[i], bri: bri_array[i]) 
				light.save 
				sleep(0.2)
			end

		end
	end

	def party_off
		log("no more party :(")
		Rails.application.config.is_party_on = false
	end

	def check_party
		if Rails.application.config.is_party_on 
			party_off
		end
	end

	def sse_update
		# Change the value so sse_update_controller knows to send an event
		Rails.application.config.sse_int += 1
	end
end
