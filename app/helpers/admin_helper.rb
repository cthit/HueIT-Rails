module AdminHelper

	#needs to be refactored(works at least)
	def active_booking
		token = "29819a3828fbf0c957a16ce8c95a6129"
		url = "https://bookit.chalmers.it/current.json"
		
		response = HTTParty.get(
  			url, 
  			headers: {"Authorization" => "Token token=#{token}"}
		)
		booking = JSON.parse(response.body)
		@group = booking["group"]
		@exp_date = booking["end_date"]
		booking["group"]
	end

	def check_lock_state
		#Gets all lockstates orders by creation and gets the latest one
		latest_lock = LockState.order(:created_at).last
		#if exp date is later than current time
		if latest_lock.present? and latest_lock.expiration_date >= Time.now
			#checks lock state
			if latest_lock.state.eql?("locked")
				@is_locked = true
				#call to active booking to get @group (can this be done better?)
				active_booking
				unless current_user.in_group?(@group.to_s) || current_user.admin?
					render :file => "app/views/lights/lock.html", :status => :unauthorized
				end
			end
		end
		@is_locked
	end
end
