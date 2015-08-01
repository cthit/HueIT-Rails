class AdminController < ActionController::Base
	include AdminHelper
  	helper_method :current_user

  	rescue_from SecurityError, with: :not_signed_in
	def index
		#Gets entries from last 3 hours
		@log_entries = LogEntry.where("created_at >= ?", Time.now - 3.hour)
	end

	def lock
		#Call to active_booking to get @group, can this be done less ugly?
		active_booking
		if current_user.in_group?(@group) || current_user.admin?
			#If the params of url are valid
			if params[:lock_type].eql?("only_group") || params[:lock_type].eql?("only_admin") || params[:lock_type].eql?("unlocked")
				#Create new lockstate using params
				lock_state = LockState.new
				lock_state.state = params[:lock_type]
				if @group 
					lock_state.group = @group
					lock_state.expiration_date = @exp_date
				else
					lock_state.group = "digit"
					lock_state.expiration_date = DateTime.now + 1.hour
				end
				lock_state.user = current_user.cid
				lock_state.save
				#To print later
				@lock_type = params[:lock_type]
			else
				@lock_type = "INVALID TYPE"
			end  
		end
	end
	
    def allow_iframe
      response.headers['X-Frame-Options'] = 'ALLOW-FROM https://chalmers.it'
    end

    def not_signed_in
      render text: 'Logga in på: <a href="https://account.chalmers.it" target="_top">https://account.chalmers.it</a>'
    end
end