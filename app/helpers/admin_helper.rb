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

  	def current_user
  		if session[:cookie] == cookies[:chalmersItAuth] && session[:user].present?
  			@user ||= User.find(session[:user])
		else
			reset_session
			@user = User.find_by_token cookies[:chalmersItAuth]
			session[:cookie] = cookies[:chalmersItAuth]
			session[:user] = @user.cid
  	  	end
  		@user
  	end
end
