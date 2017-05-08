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

	def is_locked?
		$locked_until ||= Time.now
		$locked_until > Time.now
  end

  def is_admin?
		current_user.in_group?($locked_by) || current_user.admin?
  end

  def check_lock_state
    redirect_to root_url if is_locked? && !is_admin?
  end
end
