class AdminController < ApplicationController
	include AdminHelper
  	helper_method :current_user
  	before_action :active_booking
  	rescue_from SecurityError, with: :not_signed_in
	def index
		@log_entries = LogEntry.paginate(:page => params[:page], per_page: 15).order(id: :desc)
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
		if current_user.in_group?(@group.to_s) || current_user.admin?
			#If the params of url are valid
			if params[:lock_type].eql?("locked") || params[:lock_type].eql?("unlocked")
				#Create new lockstate using params
				lock_state = LockState.new
				lock_state.state = params[:lock_type]
				if @group 
					lock_state.group = @group
					lock_state.expiration_date = @exp_date
					@lock_type = params[:lock_type] + " until: " + @exp_date.to_s
				else
					lock_state.group = "digit"
					lock_state.expiration_date = 1.hour.from_now
					@lock_type = params[:lock_type] + " until: " + 1.hour.from_now.to_s

				end
				lock_state.user = current_user.cid
				lock_state.save
				#To print later
			else
				@lock_type = "INVALID STATE"
			end  
		end
	end
end
