class AdminController < ApplicationController
	include AdminHelper
    helper_method :current_user
    before_action :active_booking, :check_admin
    rescue_from SecurityError, with: :not_signed_in

	def index
		@log_entries = LogEntry.paginate(:page => params[:page], per_page: 15).order(id: :desc)
	end

	def lock
		shouldLock = params[:lock] == "true"
		if shouldLock
			if @group
				$is_locked = @exp_date
			else
				$is_locked = 1.hour.from_now
			end
		else
			$is_locked = Time.now
		end

		flash[:success] = "Hue is " + (shouldLock ? "locked" : "unlocked")
		redirect_to admin_index_path
	end

	private
		def check_admin
			if !current_user.in_group?(@group.to_s) || current_user.admin?
				redirect_to root_url
			end
		end
end
