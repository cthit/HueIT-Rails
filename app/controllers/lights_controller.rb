class LightsController < ApplicationController
	include AdminHelper

	before_action :check_lock_state, except: [:index]

	def change_logger
		@@change_logger ||= Logger.new("#{Rails.root}/log/change.log")
	end
#Creates sites
	def index
		begin
			@lights = Huey::Bulb.all

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
		lights = params[:lights].keys

		@changedLights = ""

		lights.each do |light|
			bulb = Huey::Bulb.find light.to_i
			bulb.update(sat: (params[:sat]).to_i, hue: (params[:hue].to_i), bri: (params[:bri].to_i))
			bulb.save
			@changedLights += light.to_s+" "
		end
		
		@user = User.find_by_token cookies[:chalmersItAuth]
		change_logger.info "#{@user.cid}: Lamps ##{@changedLights}color changed to #{(params[:rgb][:color]).to_s}"
		log("Lamps ##{@changedLights}color changed to #{(params[:rgb][:color]).to_s}")

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
			light.update(rgb: '#cff974', bri: 200)
			light.save
		end

		@user = User.find_by_token cookies[:chalmersItAuth]
		change_logger.info "#{@user.cid}: All lamps reset"
		log("All lamps reset")
		
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

		lights_group.update(on: false, bri: 200, transitiontime: 0)

		@lights = Huey::Bulb.all
		respond_to do |format|
			format.js
		end
		log("All lights OFF")
	end

	def turn_all_on
		lights_group = Huey::Group.new(Huey::Bulb.find(1),Huey::Bulb.find(2),Huey::Bulb.find(3),
			Huey::Bulb.find(4), Huey::Bulb.find(5), Huey::Bulb.find(6))

		lights_group.update(on: true, bri: 200, transitiontime: 0)

		@lights = Huey::Bulb.all
		respond_to do |format|
			format.js
		end
		log("All lights ON")
	end
#Toggles light state
	def switchOnOff
		@light = Huey::Bulb.find(params[:id].to_i)
		@light.on = !@light.on
		@light.save
		log("Lamp ##{params[:id]} toggled")
	end
	
	private
	def log(change)
		entry = LogEntry.new
		@user = User.find_by_token cookies[:chalmersItAuth]
		entry.cid = @user.cid
		entry.change = change
		entry.save
	end

	def check_lock_state
		#Gets all lockstates orders by creation and gets the latest one
		latest_lock = LockState.order(:created_at).last
		#if exp date is later than current time
		if latest_lock.expiration_date >= Time.now
			#checks lock state
			if latest_lock.state.eql?("only_group") || latest_lock.state.eql?("only_admin")
				#call to active booking to get @group (can this be done better?)
				active_booking
				unless current_user.in_group(@group) || current_user.admin?
					render :file => "app/views/lights/lock.html", :status => :unauthorized
				end
			end
		end
	end
end
