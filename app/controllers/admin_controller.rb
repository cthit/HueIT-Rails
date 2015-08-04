class AdminController < ActionController::Base
	include AdminHelper
  	helper_method :current_user

  	rescue_from SecurityError, with: :not_signed_in
	def index
		#Gets last 50 entries
		@log_entries = LogEntry.last(30)
		@is_locked = locked?
	end

	def lock
		index
	end

	def locked?
		check_lock_state
		@is_locked
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
					@lock_type = params[:lock_type] + " until: " + @exp_date.to_s
				else
					lock_state.group = "digit"
					lock_state.expiration_date = DateTime.now + 1.hour
					@lock_type = params[:lock_type] + " until: " + (DateTime.now + 1.hour).to_s

				end
				lock_state.user = current_user.cid
				lock_state.save
				#To print later
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