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

	def is_locked
		if $is_locked == nil
			$is_locked = Time.now
		end
		$is_locked > Time.now
  end
end
