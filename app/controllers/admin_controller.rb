class AdminController < ApplicationController
	include AdminHelper
    helper_method :current_user
    before_action :active_booking, :check_admin
    rescue_from SecurityError, with: :not_signed_in

	def index
		@log_entries = LogEntry.paginate(:page => params[:page], per_page: 15).order(id: :desc)
	end

	def lock
		should_lock = params[:lock] == "true"
		if should_lock
			if @group
				$locked_by = @group
				$locked_until = @exp_date
			else
				$locked_by = ""
				$locked_until = 1.hour.from_now
			end
		else
			$locked_by = ""
			$locked_until = Time.now
		end

		flash[:success] = "Hue is " + (should_lock ? "locked" : "unlocked")
		redirect_to admin_index_path
	end

	private
		def check_admin
			redirect_to root_url if !is_admin?
		end
end
